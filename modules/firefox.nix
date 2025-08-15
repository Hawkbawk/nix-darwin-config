{ pkgs, ... }: {
  programs.firefox = {
    enable = true;

    # Use Firefox from nixpkgs
    package = pkgs.firefox;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      search = {
        force = true;

        default = "ddg";
        order = ["ddg" "kagi" "google" "nix-packages"];
        engines = {
          kagi = {
            name = "Kagi";
            urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
            icon = "https://kagi.com/favicon.ico";
          };
          nix-packages = {
            name = "Nix Packages";
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          bing.metaData.hidden = true;
          google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };

      # Custom preferences based on your current setup
      settings = {
        # Disable Firefox studies and experiments
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # Search settings
        "browser.search.region" = "US";
        "browser.search.defaultenginename" = "Google";
        "browser.urlbar.placeholderName" = "Google";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;

        # UI preferences
        "browser.tabs.firefox-view.ui-state.tab-pickup.open" = true;
        "browser.tabs.drawInTitlebar" = false;
        "browser.tabs.loadInBackground" = false;
        "browser.tabs.groups.smart.enabled" = true;
        "browser.startup.page" = 3; # Restore previous session
        "browser.eme.ui.firstContentShown" = true;

        # Disable automatic updates (managed by Nix)
        "app.update.auto" = false;
        "app.update.enabled" = false;
        "app.update.checkInstallTime" = false;

        # Performance settings
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        # Disable Firefox Accounts and Sync
        "identity.fxaccounts.enabled" = false;
        "services.sync.enabled" = false;
        "identity.fxaccounts.remote.signup.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "services.sync.engine.addons" = false;
        "services.sync.engine.bookmarks" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.prefs" = false;
        "services.sync.engine.tabs" = false;

        # Use the new sidebar
        # "sidebar.verticalTabs" = true;
        "sidebar.new-sidebar.has-used" = true;
        "sidebar.revamp" = true;
        "sidebar.visibility" = "always-visible";
        "sidebar.revamp.round-content-area" = true;

        # Don't ask to save passwords, we do that with Bitwarden
        "signon.rememberSignons" = false;
        "signon.management.page.breach-alerts.enabled" = false;

        # Customize home page
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };

      # User.js content for additional customizations
      userChrome = "";
      userContent = "";

      # Extensions based on your current setup
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        react-devtools
        bitwarden
        okta-browser-plugin
      ];

      # Bookmarks
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Nix";
            toolbar = true;
            bookmarks = [
              {
                name = "NixOS";
                url = "https://nixos.org/";
              }
              {
                name = "Nix Darwin";
                url = "https://nix-darwin.github.io/nix-darwin/manual/";
              }
              {
                name = "Home Manager";
                url = "https://home-manager.dev/manual/unstable/options.xhtml";
              }
              {
                name = "Nix Packages";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
        ];
      };
    };
  };
}
