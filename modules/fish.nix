{ pkgs, lib, ... }:
let
  CONFIG_FILE_PATH = "~/.config/nix";
in
{
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
}
