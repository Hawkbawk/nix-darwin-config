{
  description = "Personal home-manager and nix-darwin configuration.";

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
  {
    darwinConfigurations."FCJ300HPV2" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix

        # Set Git commit hash for darwin-version.
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."ryan.hawkins" = ./home.nix;
        }
      ];
    };
  };
}
