{
  lib,
  ...
}:
{
  options.niriImport = {
    useNiri = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Niri configuration is active.";
    };
  };
}
