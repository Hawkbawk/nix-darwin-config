{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Ryan Hawkins";
    userEmail = "ryan.hawkins@instructure.com";

    delta.enable = true;
    delta.options = {
      dark = false;
      navigate = true;
      line-numbers = true;
      hyperlinks = true;
      hyperlinks-file-link-format = "file://file/{path}:{line}";
    };

    # For now, ignore anything from devenv. Not quite ready to introduce this to everybody,
    # but it will be useful in the future.
    ignores = [
      # BEGIN devenv ignores
      ".devenv*"
      "devenv.local.nix"
      ".direnv"
      ".pre-commit-config.yaml"
      "devenv.nix"
      "devenv.lock"
      "devenv.yaml"
      "devenv.yml"
      ".envrc"
      ".env"
      # END devenv ignores
    ];

    extraConfig = {
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      filter."lfs" = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };
}
