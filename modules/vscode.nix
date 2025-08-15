{ pkgs, config, ... }: {
  programs.vscode = {
    enable = true;



    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      extensions = with pkgs.vscode-marketplace; [
        # Language Support
        pkgs.vscode-marketplace.shopify.ruby-lsp
        tamasfe.even-better-toml
        redhat.vscode-yaml
        redhat.vscode-xml
        yzhang.markdown-all-in-one
        graphql.vscode-graphql-syntax
        graphql.vscode-graphql

        # Themes
        jdinhlife.gruvbox

        # AI & Productivity
        github.copilot
        github.copilot-chat

        # Development Tools
        eamodio.gitlens
        dbaeumer.vscode-eslint
        biomejs.biome
        pkgs.vscode-marketplace.orta.vscode-jest
        steoates.autoimport
        mtxr.sqltools
        mtxr.sqltools-driver-pg
        firefox-devtools.vscode-firefox-debug

        # Remote Development
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        ms-vscode.remote-explorer
        ms-vscode.remote-repositories

        # Editor Enhancement
        vscodevim.vim
        dnut.rewrap-revived
        alefragnani.bookmarks
        alefragnani.project-manager

        # Utilities
        mikestead.dotenv
        simonsiefke.svg-preview
        mtxr.sqltools
        rangav.vscode-thunder-client
      ];




      userSettings = {
        "[git-commit]" = {
          "editor.rulers" = [ 50 72 ];
          "editor.wordWrap" = "bounded";
          "rewrap.autoWrap.enabled" = true;
          "editor.wordWrapColumn" = 72;
          "workbench.editor.restoreViewState" = false;
        };
        "[html]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
        "[markdown]" = {
          "editor.quickSuggestions" = {
            "comments" = "off";
            "other" = "off";
            "strings" = "off";
          };
        };
        "[ruby]" = {
          "editor.defaultFormatter" = "Shopify.ruby-lsp";
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;
          "editor.insertSpaces" = true;
          "editor.semanticHighlighting.enabled" = true;
          "editor.tabSize" = 2;
          "files.trimFinalNewlines" = true;
        };
        "[javascriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[graphql]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "debug.javascript.autoAttachFilter" = "disabled";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.accessibilitySupport" = "off";
        "editor.fontFamily" = "FiraCode Nerd Font Mono";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 16;
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "file";
        "editor.inlineSuggest.enabled" = true;
        "editor.rulers" = [ 120 ];
        "editor.suggestSelection" = "first";
        "editor.tabSize" = 2;
        "editor.unicodeHighlight.invisibleCharacters" = false;
        "editor.unicodeHighlight.nonBasicASCII" = false;
        "editor.codeActionsOnSave" = {
          "source.removeUnusedImports" = "always";
        };

        "emmet.includeLanguages" = {
          "django-html" = "html";
          "ejs" = "html";
          "phoenix-heex" = "html";
          "heex" = "html";
        };

        "eslint.format.enable" = true;
        "eslint.run" = "onSave";
        "eslint.validate" = [ "javascript" "typescript" "typescriptreact" "javascriptreact" ];

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.ignoreRecommendations" = true;

        "files.autoSave" = "onFocusChange";
        "files.associations" = {
          "*.html.heex" = "phoenix-heex";
        };
        "files.exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.project" = true;
          "**/.settings" = true;
        };
        "files.insertFinalNewline" = true;
        "files.simpleDialog.enable" = true;
        "files.trimTrailingWhitespace" = true;
        "files.watcherExclude" = {
          "**/.ammonite" = true;
          "**/.bloop" = true;
          "**/.metals" = true;
        };

        "git.alwaysShowStagedChangesResourceGroup" = true;
        "git.decorations.enabled" = true;
        "git.ignoreMissingGitWarning" = true;
        "git.openRepositoryInParentFolders" = "never";
        "git.suggestSmartCommit" = false;
        "git.useEditorAsCommitInput" = true;

        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = false;
          "scminput" = false;
          "git-commit" = false;
        };
        "github.copilot.chat.codesearch.enabled" = true;
        "github.copilot.chat.editor.temporalContext.enabled" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "github.copilot.chat.search.semanticTextResults" = true;
        "github.copilot.chat.languageContext.typescript.enabled" = true;
        "github.copilot.chat.agent.thinkingTool" = true;
        "github.copilot.chat.completionContext.typescript.mode" = "sidecar";

        "html.format.templating" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "typescript.tsserver.maxTsServerMemory" = 32000;
        "typescript.tsserver.web.typeAcquisition.enabled" = true;
        "typescript.tsserver.watchOptions" = {};
        "typescript.tsserver.nodePath" = "node";
        "typescript.preferences.includePackageJsonAutoImports" = "on";
        "typescript.preferences.preferTypeOnlyAutoImports" = true;

        "projectManager.git.baseFolders" = [ "~/Code" "~/go/src/github.com" "~/dev" ];
        "projectManager.git.maxDepthRecursion" = 0;

        "rubyLsp.formatter" = "rubocop";
        "rubyLsp.rubyVersionManager" = {
          "identifier" = "auto";
        };

        "search.exclude" = {
          "**/deps" = true;
          "**/.elixir_ls" = true;
          "**/_build" = true;
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
          "**/.ruby-lsp" = true;
        };
        "search.useIgnoreFiles" = false;
        "security.workspace.trust.untrustedFiles" = "open";

        "terminal.external.osxExec" = "Warp.app";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.fontSize" = 14;
        "terminal.integrated.scrollback" = 10000;
        "terminal.integrated.tabs.enabled" = true;
        "terminal.integrated.enableVisualBell" = true;
        "terminal.integrated.profiles.osx" = {
          "bash" = {
            "path" = "bash";
            "args" = [ "-l" ];
            "icon" = "terminal-bash";
          };
          "zsh" = {
            "path" = "zsh";
            "args" = [ "-l" ];
          };
          "fish" = {
            "path" = "${config.programs.fish.package}/bin/fish";
            "args" = [ "-l" ];
          };
          "tmux" = {
            "path" = "tmux";
            "icon" = "terminal-tmux";
          };
          "pwsh" = {
            "path" = "pwsh";
            "icon" = "terminal-powershell";
          };
        };
        "terminal.integrated.defaultProfile.osx" = "fish";

        "vim.autoindent" = true;
        "vim.easymotion" = true;
        "vim.foldfix" = true;
        "vim.handleKeys" = {
          "<C-i>" = false;
          "<C-o" = false;
          "<C-a>" = false;
          "<C-f>" = false;
        };
        "vim.hlsearch" = true;
        "vim.incsearch" = true;
        "vim.leader" = "<space>";
        "vim.overrideCopy" = true;
        "vim.sneak" = true;
        "vim.useCtrlKeys" = true;
        "vim.useSystemClipboard" = true;
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "<C-n>" ];
            "commands" = [ ":nohl" ];
          }
          {
            "before" = [ "[" "d" ];
            "commands" = [ "editor.action.marker.prev" ];
          }
          {
            "before" = [ "]" "d" ];
            "commands" = [ "editor.action.marker.next" ];
          }
          {
            "before" = [ "K" ];
            "commands" = [ "editor.action.showHover" ];
          }
          {
            "before" = [ "g" "r" ];
            "commands" = [ "editor.action.goToReferences" ];
          }
          {
            "before" = [ "g" "R" ];
            "commands" = [ "editor.action.rename" ];
          }
          {
            "before" = [ "<leader>" "d" "d" ];
            "commands" = [ "editor.debug.action.toggleBreakpoint" ];
          }
          {
            "before" = [ "<leader>" "d" "c" ];
            "commands" = [ "editor.debug.action.continue" ];
          }
          {
            "before" = [ "<leader>" "d" "s" ];
            "commands" = [ "editor.debug.action.stepOver" ];
          }
          {
            "before" = [ "<leader>" "d" "i" ];
            "commands" = [ "editor.debug.action.stepInto" ];
          }
          {
            "before" = [ "<leader>" "d" "o" ];
            "commands" = [ "editor.debug.action.stepOut" ];
          }
          {
            "before" = [ "<leader>" "d" "t" ];
            "commands" = [ "editor.debug.action.toggleRepl" ];
          }
          {
            "before" = [ "<leader>" "b" "t" ];
            "commands" = [ "bookmarks.toggle" ];
          }
          {
            "before" = [ "<leader>" "b" "n" ];
            "commands" = [ "bookmarks.jumpToNext" ];
          }
          {
            "before" = [ "<leader>" "b" "p" ];
            "commands" = [ "bookmarks.jumpToPrevious" ];
          }
          {
            "before" = [ "<leader>" "b" "l" ];
            "commands" = [ "bookmarks.listFromAllFiles" ];
          }
          {
            "before" = [ "g" "d" ];
            "commands" = [ "editor.action.goToDeclaration" ];
          }
          {
            "before" = [ "g" "i" ];
            "commands" = [ "editor.action.goToImplementation" ];
          }
          {
            "before" = [ "g" "s" ];
            "commands" = [ "editor.action.goToSymbol" ];
          }
          {
            "before" = [ "g" "f" ];
            "commands" = [ "editor.action.formatDocument" ];
          }
          {
            "before" = [ "<leader>" "a" ];
            "commands" = [ "editor.action.codeAction" ];
          }
          {
            "before" = [ "<leader>" "r" ];
            "commands" = [ "editor.action.rename" ];
          }
          {
            "before" = [ "<leader>" "e" ];
            "commands" = [ "workbench.files.action.focusFilesExplorer" ];
          }
          {
            "before" = [ "<leader>" "/" ];
            "commands" = [ "workbench.view.search" ];
          }
          {
            "before" = [ "<leader>" "f" ];
            "commands" = [ "workbench.action.quickOpen" ];
          }
          {
            "before" = [ "<C-h>" ];
            "after" = [ "<C-w>" "h" ];
          }
          {
            "before" = [ "<C-l>" ];
            "after" = [ "<C-w>" "l" ];
          }
        ];

        "window.dialogStyle" = "custom";
        "window.restoreWindows" = "none";
        "window.title" = "\${rootName}";

        "workbench.colorTheme" = "Solarized Light";
        "workbench.colorCustomizations" = {
          "activityBar.activeBorder" = "#388E3C";
          "activityBarBadge.background" = "#388E3C";
          "breadcrumb.activeSelectionForeground" = "#388E3C";
          "editor.findMatchBorder" = "#388E3C";
          "editorSuggestWidget.highlightForeground" = "#388E3C";
          "editorWidget.border" = "#388E3C";
          "editorWidget.resizeBorder" = "#388E3C";
          "list.activeSelectionForeground" = "#388E3C";
          "list.highlightForeground" = "#388E3C";
          "list.inactiveSelectionForeground" = "#388E3C";
          "menu.selectionForeground" = "#388E3C";
          "menubar.selectionForeground" = "#388E3C";
          "notificationLink.foreground" = "#388E3C";
          "panelTitle.activeBorder" = "#388E3C";
          "pickerGroup.foreground" = "#388E3C";
          "progressBar.background" = "#388E3C";
          "scrollbarSlider.activeBackground" = "#388E3C50";
          "selection.background" = "#388E3C40";
          "settings.headerForeground" = "#388E3C";
          "settings.modifiedItemIndicator" = "#388E3C";
          "statusBarItem.remoteBackground" = "#388E3C";
          "tab.activeBorder" = "#388E3C";
          "textLink.foreground" = "#388E3C";
        };
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 8;
        "workbench.editor.empty.hint" = "hidden";

        "redhat.telemetry.enabled" = false;
        "accessibility.signals.terminalBell" = {
          "sound" = "on";
        };
        "biome.suggestInstallingGlobally" = false;
        "gitlens.launchpad.indicator.enabled" = false;
        "jest.runMode" = "on-demand";
        "jest.nodeEnv" = {
          "NODE_ENV" = "test";
        };
        "remote.autoForwardPortsSource" = "hybrid";

        "sqltools.connections" = [
          {
            "previewLimit" = 50;
            "server" = "postgres";
            "port" = 5432;
            "driver" = "PostgreSQL";
            "name" = "Canvas Postgres";
            "database" = "canvas_development";
            "username" = "postgres";
            "password" = "sekret";
          }
        ];
      };

      keybindings = [
        {
          "key" = "ctrl+meta+n";
          "command" = "gitProjectManager.openProjectNewWindow";
        }
        {
          "key" = "ctrl+alt+n";
          "command" = "-gitProjectManager.openProjectNewWindow";
        }
        {
          "key" = "ctrl+meta+s";
          "command" = "projectManager.saveProject";
        }
        {
          "key" = "cmd+t";
          "command" = "workbench.action.terminal.toggleTerminal";
        }
        {
          "key" = "ctrl+shift+t";
          "command" = "workbench.action.terminal.new";
        }
        {
          "key" = "shift+alt+cmd+n";
          "command" = "workbench.action.duplicateWorkspaceInNewWindow";
        }
        {
          "key" = "ctrl+shift+cmd+h";
          "command" = "opensshremotes.openEmptyWindowInCurrentWindow";
        }
        {
          "key" = "space+e";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "filesExplorerFocus";
        }
        {
          "key" = "o";
          "command" = "explorer.openAndPassFocus";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsFolder && !inputFocus";
        }
        {
          "key" = "enter";
          "command" = "explorer.openAndPassFocus";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsFolder";
        }
        {
          "key" = "r";
          "command" = "renameFile";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "cmd+e";
          "command" = "-actions.findWithSelection";
        }
        {
          "key" = "cmd+e";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "!editorFocus";
        }
        {
          "key" = "a";
          "command" = "workbench.files.action.createFileFromExplorer";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "ctrl+o";
          "command" = "workbench.action.navigateBack";
          "when" = "canNavigateBack";
        }
        {
          "key" = "ctrl+-";
          "command" = "-workbench.action.navigateBack";
          "when" = "canNavigateBack";
        }
        {
          "key" = "ctrl+i";
          "command" = "workbench.action.navigateForward";
          "when" = "canNavigateForward";
        }
        {
          "key" = "ctrl+shift+-";
          "command" = "-workbench.action.navigateForward";
          "when" = "canNavigateForward";
        }
        {
          "key" = "cmd+r";
          "command" = "chat.action.focus";
          "when" = "!editorTextFocus";
        }
        {
          "key" = "shift+cmd+.";
          "command" = "codelens.showLensesInCurrentLine";
          "when" = "editorTextFocus && editorHasCodeLensProvider";
        }
        {
          "key" = "cmd+r";
          "command" = "workbench.panel.chat";
          "when" = "workbench.panel.chat.view.copilot.active";
        }
        {
          "key" = "ctrl+cmd+i";
          "command" = "-workbench.panel.chat";
          "when" = "workbench.panel.chat.view.copilot.active";
        }
        {
          "key" = "cmd+n";
          "command" = "workbench.action.chat.newChat";
          "when" = "chatIsEnabled && inChat && !config.chat.unifiedChatView && chatLocation != 'editing-session'";
        }
        {
          "key" = "ctrl+l";
          "command" = "-workbench.action.chat.newChat";
          "when" = "chatIsEnabled && inChat && !config.chat.unifiedChatView && chatLocation != 'editing-session'";
        }
        {
          "key" = "cmd+n";
          "command" = "workbench.action.files.newUntitledFile";
          "when" = "editorFocus";
        }
        {
          "key" = "cmd+n";
          "command" = "-workbench.action.files.newUntitledFile";
        }
        {
          "key" = "cmd+n";
          "command" = "workbench.action.chat.newEditSession";
          "when" = "chatEditingParticipantRegistered && chatIsEnabled && inChat";
        }
        {
          "key" = "ctrl+l";
          "command" = "-workbench.action.chat.newEditSession";
          "when" = "chatEditingParticipantRegistered && chatIsEnabled && inChat";
        }
        {
          "key" = "cmd+n";
          "command" = "workbench.action.terminal.new";
          "when" = "terminalFocus";
        }
      ];
    };
  };
}
