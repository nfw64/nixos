{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "Bongocat";
      version = "main";
      src = inputs.bongocat;

      buildFlags = ["all" "extra-target"];
      installTargets = ["install-binaries"];
    })
  ];
}
