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
    homeconfig = {pkgs, ...}:
    let
      CONFIG_FILE_PATH = "~/.config/nix";
    in
    {
      # this is internal compatibility configuration for home-manager, don't
      # change this! It should match the first version of nixpkgs that was
      # installed on this system with home-manager.
      home.stateVersion = "25.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        pkgs.neovim
        pkgs.nodejs_24
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
      };

      programs.fish = {
        enable = true;
        shellAliases = {
          open-nix-config = "$EDITOR ${CONFIG_FILE_PATH}/flake.nix";
        };
        functions = {
          rebuild-nix-conf = ''
            echo "🔧 About to rebuild nix-darwin configuration..."
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
