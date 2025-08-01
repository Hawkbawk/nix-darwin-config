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
    pkgs.zed-editor
    pkgs.fzf
    pkgs.ripgrep
    pkgs.devenv
    pkgs.nodejs_24
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
    ./modules/caddy.nix
    ./modules/git.nix
  ];
}
