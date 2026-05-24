{
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../../home/sharedVars.nix
    ../../home/imports.nix
    ./packages.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/nixos/assets/scripts"
    ];

    username = "myriad";
    homeDirectory = "/home/myriad";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      NH_FLAKE = "${config.home.homeDirectory}/nixos/";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
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
