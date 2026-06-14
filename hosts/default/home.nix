{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home/imports.nix
    ./packages.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/nixos/assets/scripts"
    ];

    username = "myriad";
    homeDirectory = "/home/myriad";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      NH_FLAKE = "${config.home.homeDirectory}/nixos/";
      BITWARDEN_SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/bitwarden-ssh-agent.sock";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/bitwarden-ssh-agent.sock";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Megumin"; # Make sure this matches your folder name capitalization
    size = 64;

    # No build dependencies needed anymore, just a dead-simple folder mirror
    package = pkgs.runCommand "pointerCursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../assets/local/cursor/Megumin} $out/share/icons/Megumin
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "bluegrey";
      };
    };

    gtk3.extraCss = ''@import url("file:///${config.home.homeDirectory}/.cache/matugen/colors-gtk.css");'';
    gtk4.extraCss = ''@import url("file:///${config.home.homeDirectory}/.cache/matugen/colors-gtk.css");'';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 0;
      gtk-menu-images = 0;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 0;
      gtk-menu-images = 0;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };
}
