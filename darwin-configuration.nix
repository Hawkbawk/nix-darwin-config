{ pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [];
  environment.defaultPackages = [
    pkgs.fish
  ];

  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [];
      brews = [];
      # None of these casks are available in nixpkgs, likely because they're macOS
      # specific
      casks = ["orbstack" "devpod" "insomnia" "raycast" "warp" "handbrake" "sanesidebuttons"];
  };

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
}
