{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "ruby" "biome"];
    extraPackages = [pkgs.ruby_3_4 pkgs.nixd pkgs.nil pkgs.nodejs_24];

    userSettings = {
      theme = "Gruvbox Light Hard";

      agent = {
        play_sound_when_agent_done = true;
        always_allow_tool_actions = true;
        default_profile = "write";

        profiles = {
          basic-chat = {
            name = "Basic Chat";
            tools = {
              terminal = false;
            };
            enable_all_context_servers = false;
            context_servers = {};
          };

          write = {
            name = "Write";
            tools = {
              terminal = true;
              batch_tool = true;
              code_symbols = true;
              copy_path = false;
              create_file = true;
              delete_path = false;
              diagnostics = true;
              edit_file = true;
              fetch = true;
              list_directory = false;
              move_path = false;
              now = true;
              find_path = true;
              read_file = true;
              grep = true;
              symbol_info = true;
              thinking = true;
            };
            enable_all_context_servers = true;
            context_servers = {
              mcp-server-puppeteer = {
                tools = {
                  puppeteer_select = true;
                  puppeteer_screenshot = true;
                  puppeteer_navigate = true;
                  puppeteer_hover = true;
                  puppeteer_fill = true;
                  puppeteer_evaluate = true;
                  puppeteer_click = true;
                };
              };
              postgres-context-server = {
                tools = {
                  query = true;
                  pg-schema = true;
                };
              };
            };
          };
        };

        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
        };
      };

      icon_theme = "Zed (Default)";

      features = {
        edit_prediction_provider = "copilot";
      };

      ssh_connections = [
        {
          host = "canvas-lms.devpod";
          projects = [
            { paths = ["/usr/src/app"]; }
          ];
        }
      ];

      vim_mode = true;
      base_keymap = "VSCode";
      ui_font_family = "FiraCode Nerd Font Mono";
      buffer_font_family = "FiraCode Nerd Font Mono";
      ui_font_size = 16;
      buffer_font_size = 16;

      terminal = {
        font_family = "FiraCode Nerd Font Mono";
      };

      vim = {
        use_smartcase_find = true;
      };

      lsp = {
        biome = {
          settings = {
            require_config_file = false;
          };
        };
        ruby-lsp = {
          initialization_options = {
            binary = {
              path = "ruby-lsp";
            };
            enabledFeatures = {
              formatting = true;
            };
          };
        };
      };

      languages = {
        Ruby = {
          show_edit_predictions = true;
          language_servers = [
            "ruby-lsp"
            "rubocop"
            "!solargraph"
            "!sorbet"
            "..."
          ];
          formatter = "language_server";
        };
      };

      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "errors";
      };

      file_finder = {
        include_ignored = true;
      };

      command_aliases = {
        t = "task::Spawn";
      };

      use_system_prompts = false;
      use_system_path_prompts = false;

      formatter = {
        language_server = {
          name = "biome";
        };
      };

      message_editor = {
        auto_replace_emoji_shortcode = true;
      };

      minimap = {
        show = "auto";
      };

      code_actions_on_format = {
        "source.fixAll.biome" = true;
      };

      debugger = {
        format_dap_log_messages = true;
        log_dap_communications = true;
        stepping_granularity = "statement";
      };
    };

    userKeymaps = [
        {
          context = "Editor && vim_mode == normal";
          bindings = {
            "g R" = "editor::Rename";
            "g r" = "editor::FindAllReferences";
          };
        }
        {
          context = "Editor && vim_mode == normal && (vim_operator == none || vim_operator == n) && !VimWaiting";
          bindings = {
            "space d b" = "editor::ToggleBreakpoint";
            "space d s" = "debugger::Start";
            "space d S" = "debugger::Stop";
            "space d c" = "debugger::Continue";
          };
        }
        {
          context = "Editor";
          bindings = {
            "cmd-k p" = "workspace::CopyRelativePath";
          };
        }
        {
          bindings = {
            "cmd-shift-g" = "git_panel::ToggleFocus";
            "cmd-t" = "terminal_panel::ToggleFocus";
            "cmd-d" = "workspace::ToggleBottomDock";
          };
        }
        {
          context = "(((Editor && vim_mode == normal) && (vim_operator == none || vim_operator == n)) && !VimWaiting)";
          bindings = {
            "space g b" = "editor::OpenGitBlameCommit";
          };
        }
        {
          context = "MessageEditor > (Editor && VimControl)";
          bindings = {
            "cmd-enter" = "agent::Chat";
          };
        }
        {
          context = "MessageEditor > (Editor && VimControl)";
          bindings = {
            "enter" = null;
          };
        }
      ];
  };
}
