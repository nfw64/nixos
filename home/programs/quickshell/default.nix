{
  pkgs,
  config,
  self,
  ...
}:
{

  home.packages = with pkgs; [
    quickshell
    jq
    brightnessctl
    nmcli
    awww
  ];

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${self}/home/programs/quickshell/assets";

}
