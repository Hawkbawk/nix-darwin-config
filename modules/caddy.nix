{ pkgs, lib, ... }:
let
  CADDY_CONFIG_DIR = "~/.config/caddy";
  CADDY_LOG_FILE = "/Users/ryan.hawkins/.local/share/caddy/logs/caddy.log";
  CANVAS_PORT = 8888;
  CANVAS_ASSETS_PORT = 8889;
in
{
  home.packages = with pkgs; [
    pkgs.caddy
  ];

  # Create Caddy configuration directory and default Caddyfile if it doesn't exist
  home.activation.createCaddyfile = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CADDY_CONFIG_DIR="$HOME/.config/caddy"
    CADDY_CONFIG_FILE="$CADDY_CONFIG_DIR/Caddyfile"

    if [ ! -f "$CADDY_CONFIG_FILE" ]; then
      echo "Creating default Caddyfile..."
      if [ "$\{DRY_RUN:-\}" != "1" ]; then
        mkdir -p "$CADDY_CONFIG_DIR"
        cat > "$CADDY_CONFIG_FILE" << 'EOF'
{
    log {
        output file ${CADDY_LOG_FILE}
        format json
    }
}

https://canvas.localhost, https://*.canvas.localhost {
    reverse_proxy localhost:${toString CANVAS_PORT}
    tls internal
}

https://canvas-assets.localhost {
    reverse_proxy localhost:${toString CANVAS_ASSETS_PORT}
    tls internal
}

# To add additional services or sites, you can append them here.
# For example:
# https://example.localhost {
#    reverse_proxy localhost:1234
#    tls internal
# }
# It is up to you to get the port correct and ensure that the service is running.
EOF
        echo "Default Caddyfile created at $CADDY_CONFIG_FILE"
      else
        echo "DRY_RUN: Would create default Caddyfile at $CADDY_CONFIG_FILE"
      fi
    else
      echo "Caddyfile already exists at $CADDY_CONFIG_FILE, skipping creation"
    fi

    # Install Caddy's root CA certificate for trusted HTTPS
    echo "Setting up Caddy root CA trust..."
    if [ "$\{DRY_RUN:-\}" != "1" ]; then
      ${pkgs.caddy}/bin/caddy trust 2>/dev/null || echo "Note: Caddy trust setup may require manual intervention"
    else
      echo "DRY_RUN: Would run caddy trust"
    fi
  '';

  # Create Caddy logs directory
  home.file.".local/share/caddy/logs/.keep" = {
    text = "";
  };

  # Caddy launchd service
  launchd.agents.caddy = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.caddy}/bin/caddy"
        "run"
        "--config"
        "/Users/ryan.hawkins/.config/caddy/Caddyfile"
        "--watch"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${CADDY_LOG_FILE}";
      StandardErrorPath = "${CADDY_LOG_FILE}";
      WorkingDirectory = "/Users/ryan.hawkins";
    };
  };

  # Daily Caddy log cleanup service
  launchd.agents.caddy-log-cleanup = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "echo 'Clearing Caddy logs...' && > '${CADDY_LOG_FILE}' && echo 'Caddy logs cleared at $(date)'"
      ];
      StartCalendarInterval = [{
        Hour = 3;
        Minute = 0;
      }];
      StandardOutPath = "/Users/ryan.hawkins/.local/share/caddy/logs/cleanup.log";
      StandardErrorPath = "/Users/ryan.hawkins/.local/share/caddy/logs/cleanup.log";
    };
  };

  # Caddy-specific Fish functions
  programs.fish.functions = {
    caddy-logs = ''
      echo "📋 Viewing Caddy logs..."
      echo "Press Ctrl+C to exit"
      tail -f -n 500 ${CADDY_LOG_FILE}
    '';
    caddy-restart = ''
      echo "🔄 Restarting Caddy service..."
      set CADDY_SERVICE (launchctl list | grep -i caddy | awk '{print $3}' | head -1)
      if test -z "$CADDY_SERVICE"
        echo "❌ No Caddy service found. Are you sure it's running?"
        return 1
      end
      echo "Found service: $CADDY_SERVICE"
      launchctl stop "$CADDY_SERVICE"
      sleep 1
      launchctl start "$CADDY_SERVICE"
      echo "✅ Caddy service restarted"
    '';
  };
}
