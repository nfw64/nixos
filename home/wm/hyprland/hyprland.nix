{
  pkgs,
  config,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos";
  create-symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  homeFiles = {
    ".local/bin" = "configs/.local/bin";
    ".local/share/templates" = "configs/.local/share/templates";
  };
  configs = {
    hypr = "hypr";
    flameshot = "flameshot";
  };
in {
  xdg.configFile =
    (builtins.mapAttrs (name: subpath: {
        source = create-symlink "${dotfiles}/home/wm/hyprland/configs/.config/${subpath}";
        recursive = true;
      })
      configs)
    // {
      # Needs this since xdg-desktop-portal wont run for some reason on hyprland or misconfiguration
      # refer https://github.com/flatpak/xdg-desktop-portal/issues/1983#issuecomment-4692177402
      "systemd/user/xdg-desktop-portal.service".text = ''
        [Unit]
        Description=Portal service
        Requires=dbus.service
        After=dbus.service

        [Service]
        Type=dbus
        BusName=org.freedesktop.portal.Desktop
        ExecStart=${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal
        Slice=session.slice
      '';
    };

  home.file =
    builtins.mapAttrs (name: subpath: {
      source = create-symlink "${dotfiles}/home/wm/hyprland/${subpath}";
    })
    homeFiles;

  home.packages = with pkgs; [
    flameshot
    grim
    pulseaudio
    slurp
    hypridle
    hyprpolkitagent
    gammastep
    geoclue2
  ];
}
