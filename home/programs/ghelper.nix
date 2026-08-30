# Managed by g-helper install script. Safe to delete (also remove the
# matching '[ /etc/nixos/ghelper.nix ] ++' from configuration.nix).
{...}: {
  imports = [./ghelper/nixos/module.nix];
  services.ghelper.enable = true;
}
