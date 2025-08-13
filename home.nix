{ pkgs, lib, ... }: {
  # this is internal compatibility configuration for home-manager, don't
  # change this! It should match the first version of nixpkgs that was
  # installed on this system with home-manager.
  home.stateVersion = "25.05";

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;
  home.shell.enableFishIntegration = true;

  home.packages = with pkgs; [
    pkgs.neovim
    pkgs.fzf
    pkgs.ripgrep
    pkgs.devenv
    pkgs.nodejs_24
    pkgs.lsof
    pkgs.code-cursor
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
    ./modules/zed.nix
  ];
}
