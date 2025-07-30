{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    # Canvas application port
    CANVAS_PORT = 8888;
    CANVAS_ASSETS_PORT = 8889;
    # Caddy log file path
    CADDY_LOG_FILE = "/Users/ryan.hawkins/.local/share/caddy/logs/caddy.log";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [];
      environment.defaultPackages = [
        pkgs.fish
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      security.pam.services.sudo_local.touchIdAuth = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users."ryan.hawkins" = {
            shell = pkgs.fish;
            name = "ryan.hawkins";
            home = "/Users/ryan.hawkins";
      };
    };
    homeconfig = {pkgs, lib, ...}:
    let
      CONFIG_FILE_PATH = "~/.config/nix";
      CADDY_CONFIG_DIR = "~/.config/caddy";
    in
    {
      # this is internal compatibility configuration for home-manager, don't
      # change this! It should match the first version of nixpkgs that was
      # installed on this system with home-manager.
      home.stateVersion = "25.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;
      home.shell.enableFishIntegration = true;

      home.packages = with pkgs; [
        pkgs.neovim
        pkgs.zed-editor
        pkgs.fzf
        pkgs.ripgrep
        pkgs.devenv
        pkgs.nodejs_24
        pkgs.caddy
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
      };

      programs.direnv = {
          enable = true;
      };

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

      programs.zoxide = {
          enable = true;
      };

      programs.fish = {
        enable = true;
        shellAliases = {
          open-nix-config = "$EDITOR ${CONFIG_FILE_PATH}/flake.nix";
          g = "git";
          gri = "git rebase --interactive";
          grh = "git reset --hard";
          reload = "source ~/.config/fish/config.fish";
          fishrc = "$EDITOR ~/.config/fish/config.fish";
          vimrc = "$EDITOR ~/.config/nvim";
          dcr = "docker compose run --rm";
          dex = "docker compose exec";
          dc = "docker compose";
          lg = "lazygit";
          grc = "git rebase --continue";
          gca = "git commit --amend";
        };
        functions = {
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
          rebuild-nix-conf = ''
            echo "🔧 About to rebuild nix-darwin configuration..."
            echo "This will require sudo access."
            read -l reply -p "set_color green; echo -n 'Are you sure you want to proceed? [y/N]: '; set_color normal"
            switch (string lower "$reply")
              case "y" "yes"
                echo "✅ Rebuilding configuration..."
                sudo darwin-rebuild switch --flake ${CONFIG_FILE_PATH}
              case "*"
                echo "❌ Rebuild cancelled."
            end
          '';
        };
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#FCJ300HPV2
    darwinConfigurations."FCJ300HPV2" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."ryan.hawkins" = homeconfig;
        }
      ];
    };
  };
}
