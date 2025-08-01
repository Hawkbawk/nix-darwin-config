{ pkgs, lib, config, ... }:
let
  CADDY_CONFIG_DIR = "${config.home.homeDirectory}/.config/caddy";
  CADDY_EXTRA_CONFIG_DIR = "${CADDY_CONFIG_DIR}/additional_files";
  CADDY_LOG_FILE = "${config.home.homeDirectory}/.local/share/caddy/logs/caddy.log";
  CANVAS_PORT = 8888;
  CANVAS_ASSETS_PORT = 8889;
  CADDYFILE = ''
{
    log {
        output file ${CADDY_LOG_FILE}
        format json
    }
}

(cors) {
	@cors_preflight method OPTIONS

	header {
		Access-Control-Allow-Origin "*"
		Access-Control-Expose-Headers "Authorization"
		Access-Control-Allow-Credentials "true"
	}

	handle @cors_preflight {
		header {
			Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE"
			Access-Control-Max-Age "3600"
		}
		respond "" 204
	}
}
# See caddy-add to add additional Caddy configs easily
import ${CADDY_EXTRA_CONFIG_DIR}/*.caddy

  '';
in
{
  home.packages = with pkgs; [
    pkgs.caddy
  ];


  # Create Caddy logs directory
  home.file.".local/share/caddy/logs/.keep" = {
    text = "";
  };

  home.file.".config/caddy/additional_files/.keep" = {
    text = "";
  };

  # If any changes need to be made to the Caddyfile, it must be checked in to the repository.
  # This prevents weird drift overtime and makes it easy to revert if something goes wrong.
  home.file.".config/caddy/Caddyfile" = {
    text = CADDYFILE;
    force = true;
  };

  # Caddy launchd service
  launchd.agents.caddy = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.caddy}/bin/caddy"
        "run"
        "--config"
        "${config.home.homeDirectory}/.config/caddy/Caddyfile"
        "--watch"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${CADDY_LOG_FILE}";
      StandardErrorPath = "${CADDY_LOG_FILE}";
      WorkingDirectory = "${config.home.homeDirectory}";
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
      StandardOutPath = "${config.home.homeDirectory}/.local/share/caddy/logs/cleanup.log";
      StandardErrorPath = "${config.home.homeDirectory}/.local/share/caddy/logs/cleanup.log";
    };
  };

  # Set environment variables for Canvas ports
  programs.fish.shellInit = ''
    set -gx CANVAS_PORT ${toString CANVAS_PORT}
    set -gx CANVAS_ASSETS_PORT ${toString CANVAS_ASSETS_PORT}
  '';

  # Caddy-specific Fish functions
  programs.fish.functions = {
    caddy-reset = ''
      echo "WARNING: This will remove any and all Caddyfile customizations you might have, including custom domain proxy configs."
      read -P "Are you sure you want to reset ALL Caddy configs? [y/N]: " confirm
      if test "$confirm" = "y" -o "$confirm" = "Y"
          echo $DEFAULT_CADDYFILE > "$CADDY_CONFIG_FILE"
          rm -r ${CADDY_EXTRA_CONFIG_DIR}/*
          echo "Caddyfile has been reset."
      else
          echo "Reset cancelled."
      end
    '';
    caddy-logs = ''
      echo "📋 Viewing Caddy logs..."
      echo "Press Ctrl+C to disconnect"
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
    caddy-add = ''
      set -l port ""
      set -l domains
      set -l cors_flag false

      # Parse arguments
      for arg in $argv
        switch $arg
          case '--cors'
            set cors_flag true
          case "--help" "-h"
            echo "Usage: caddy-add <port> <domain1> [domain2] [...] [--cors]"
            echo "Example: caddy-add 8080 example.com www.example.com --cors"
            return 0
          case '*'
            if test -z "$port"
              set port $arg
            else
              set domains $domains $arg
            end
        end
      end

      # Validate arguments
      if test -z "$port"
        echo "❌ Error: Port is required"
        echo "Usage: caddy-add <port> <domain1> [domain2] [...] [--cors]"
        return 1
      end

      if test (count $domains) -eq 0
        echo "❌ Error: At least one domain is required"
        echo "Usage: caddy-add <port> <domain1> [domain2] [...] [--cors]"
        return 1
      end

      # Validate port is numeric
      if not string match -qr '^\d+$' "$port"
        echo "❌ Error: Port must be a number"
        return 1
      end

      # Create config directory if it doesn't exist
      mkdir -p ${CADDY_EXTRA_CONFIG_DIR}

      # Generate domain list for filename (use first domain)
      set -l primary_domain $domains[1]
      set -l config_file "${CADDY_EXTRA_CONFIG_DIR}/$primary_domain.caddy"

      # Build domain string for Caddy config
      set -l domain_string ""
      for domain in $domains
        if test -z "$domain_string"
          set domain_string "https://$domain"
        else
          set domain_string "$domain_string, https://$domain"
        end
      end

      # Generate Caddy config content
      set -l config_content "$domain_string {\n    reverse_proxy localhost:$port\n    tls internal"

      if test $cors_flag = true
        set config_content "$config_content\n    import cors"
      end

      set config_content "$config_content\n}"

      # Write config file
      echo -e $config_content > "$config_file"

      echo "✅ Created Caddy config: $config_file"
      echo "📋 Domains: $domains"
      echo "🔗 Port: $port"
      if test $cors_flag = true
        echo "🌐 CORS: enabled"
      end
      echo "🔄 Restart Caddy to apply changes: caddy-restart"
    '';
    caddy-remove = ''
      set -l domain ""

      # Parse arguments
      if test (count $argv) -eq 0
        echo "❌ Error: Domain is required"
        echo "Usage: caddy-remove <domain>"
        return 1
      end

      set domain $argv[1]

      # Check if config file exists
      set -l config_file "${CADDY_EXTRA_CONFIG_DIR}/$domain.caddy"

      if not test -f "$config_file"
        echo "❌ Error: Config file for domain '$domain' not found"
        echo "Expected file: $config_file"
        return 1
      end

      # Remove config file
      rm "$config_file"

      echo "✅ Removed Caddy config for domain: $domain"
      echo "🔄 Restart Caddy to apply changes: caddy-restart"
    '';
  };
}
