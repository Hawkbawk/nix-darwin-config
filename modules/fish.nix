{ ... }:
let
  CONFIG_FILE_PATH = "~/.config/nix";
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim

    '';
    loginShellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';
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
      process-for-port = ''
        if test (count $argv) -ne 1
            echo "Usage process-for-port <port>"
            return 1
        end
        lsof -i tcp:$argv[1] | grep LISTEN
      '';
      free-port = ''
        if test (count $argv) -ne 1
          echo "Usage: free-port <port>"
          return 1
        end

        set port $argv[1]

        # Find processes listening on the port
        set pids (lsof -ti tcp:$port -s tcp:listen 2>/dev/null)

        if test -z "$pids"
          echo "No processes found listening on port $port"
          return 0
        end

        echo "Found processes listening on port $port: $pids"
        echo "Sending SIGTERM..."

        # Send SIGTERM to all processes
        for pid in $pids
          kill -TERM $pid 2>/dev/null
        end

        # Poll every second for up to 10 seconds
        set poll_count 0
        while test $poll_count -lt 10
          set remaining_pids (lsof -ti tcp:$port -s tcp:listen 2>/dev/null)

          if test -z "$remaining_pids"
            echo "All processes terminated successfully"
            return 0
          end

          set poll_count (math $poll_count + 1)
          echo "Waiting for processes to terminate... ($poll_count/10)"
          sleep 1
        end

        # If we get here, processes are still running after 10 seconds
        set remaining_pids (lsof -ti tcp:$port -s tcp:listen 2>/dev/null)
        if test -n "$remaining_pids"
          echo "Some processes still running after 10 seconds, sending SIGKILL to: $remaining_pids"
          for pid in $remaining_pids
            kill -KILL $pid 2>/dev/null
          end
        end
      '';
    };
  };
}
