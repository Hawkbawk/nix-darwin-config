{ pkgs, ... }: {
  # this is internal compatibility configuration for home-manager, don't
  # change this! It should match the first version of nixpkgs that was
  # installed on this system with home-manager.
  home.stateVersion = "25.05";

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;
  home.shell.enableFishIntegration = true;

  home.packages = with pkgs; [
    defaultbrowser
    neovim
    fzf
    ripgrep
    devenv
    nodejs_24
    lsof
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  # Import modular configurations
  imports = [
    ./modules/fish.nix
    # After a great deal of experimentation, I've decided that OrbStack and Docker
    # is the best way to go when it comes to separation of dependencies. All of the projects
    # I use already have it set up and devenv/process-compose just did not work well, especially
    # the Postgres integration. It would complain about the user not being created, despite the fact
    # I had explicitly told it to create said user. Perhaps on another day I shall revisit this, but for now,
    # OrbStack just kinda works better.
    # ./modules/caddy.nix
    ./modules/git.nix
    # I keep going back and forth on Zed. It's very slick, but the debugger just doesn't seem to work, especially
    # over SSH/remote connections. It's going to stick around for now, but just won't be enabled by default.
    # ./modules/zed.nix
    ./modules/vscode.nix
    ./modules/firefox.nix
  ];
}
