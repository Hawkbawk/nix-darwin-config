{ pkgs, config, ... }: {
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

  # Set Firefox as default browser
  system.activationScripts.setDefaultBrowser.text = ''
    # Set Firefox as default browser using defaultbrowser utility
    echo "Going to set default browser to firefox"
    if command -v defaultbrowser >/dev/null 2>&1; then
      sudo -u ${config.system.primaryUser} defaultbrowser firefox
    else
      echo "defaultbrowser utility not found. Install with: brew install defaultbrowser"
    fi
  '';

  system.activationScripts.setGrantedBrowser.text = ''
    granted browser set -b firefox -p ${pkgs.firefox}
  '';



  homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [];
      brews = [];
      # None of these casks are available in nixpkgs, likely because they're macOS
      # specific
      casks = [
        "orbstack"
        # Only really needed if I'm using Zed, which I don't use right now.
        # "devpod"
        "insomnia"
        "raycast"
        "warp"
        "sanesidebuttons"
        "alt-tab"
        "dash"
        "slack"
        "spotify"
      ];

      masApps = {
        "Magnet" = 441258766;
      };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "ryan.hawkins";

  users.users."ryan.hawkins" = {
    shell = pkgs.fish;
    name = "ryan.hawkins";
    home = "/Users/ryan.hawkins";
  };
}
