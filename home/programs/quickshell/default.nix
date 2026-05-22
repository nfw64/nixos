{
  pkgs,
  config,
  ...
}:
{

  home.packages = with pkgs; [
    quickshell
    jq
    brightnessctl
    networkmanager
    awww
  ];

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/programs/quickshell/qs";

}
