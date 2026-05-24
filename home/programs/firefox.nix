{
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta.override {
      nativeMessagingHosts = [
        pkgs.pywalfox-native
        pkgs.tridactyl-native
      ];
    };

    nativeMessagingHosts = [
      pkgs.pywalfox-native
      pkgs.tridactyl-native
    ];

    profiles.myprofile = {
      id = 0;
      name = "myriad";
      isDefault = true;

      extraConfig = builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "yokoffing";
          repo = "Betterfox";
          rev = "150.0";
          sha256 = "sha256-4YstG6vXN6K3pBve3769G0gZidB/8FzG0K/S60n53pU=";
        }
        + "/user.js"
      );

      settings = {
        # --- UI & Performance Customizations ---
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.startup.page" = 3;

        # --- Reverting some aggressive Betterfox privacy blocks (if you want history/saving) ---
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "places.history.enabled" = true;

        # --- Hardware Acceleration (Intel Integrated Graphics optimization) ---
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        # self overrides
        "browser.contentblocking.category" = "standard";
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_error_page_user_suggestions" = true;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.search.suggest.enabled" = true;
        "signon.rememberSignons" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
      };

      extensions = [ ];
    };

    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "pywalfox@frewacom.org" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "tridactyl.vim.betas@cmcaine.co.uk" = {
          install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl_beta-latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
          default_area = "addons-container";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          # bitwarden
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
