{
  lib,
  ...
}:
{
  options.Niri = {
    useNiri = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "use niri as wm";
    };
  };
  options.Hyprland = {
    useHyprland = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use hyprland as wm";
    };
  };
}
