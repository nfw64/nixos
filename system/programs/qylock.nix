{pkgs, ...}: let
  sddmThemeName = "star-rail";

  qylock-src = pkgs.fetchFromGitHub {
    owner = "Darkkal44";
    repo = "qylock";
    rev = "db61a972b4b23728d9944a906e70029ca8a5899d";
    hash = "sha256-nRDOBInhNXLGB36Me4y4q/9ph5OrAqhc5GOP1bgKQWg=";
    forceFetchGit = true;
    sparseCheckout = [
      "themes/star-rail"
    ];
  };

  qylock-sddm-pkg = pkgs.stdenvNoCC.mkDerivation {
    pname = "qylock";
    version = "custom";
    src = qylock-src;
    dontBuild = true;

    bgVid = pkgs.fetchurl {
      url = "https://huggingface.co/datasets/myriadv1/nixos-assets/resolve/main/bg.mp4";
      hash = "sha256-JrGvpMEzfqN4wXADAPchiLfvBJb2GgGvjclH5oBgW8U=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes/${sddmThemeName}
      rm -rf themes/${sddmThemeName}/bg.mp4
      cp -r themes/* $out/share/sddm/themes/
      cp $bgVid $out/share/sddm/themes/${sddmThemeName}/bg.mp4

      runHook postInstall
    '';
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = sddmThemeName;
    extraPackages = [
      qylock-sddm-pkg
      pkgs.qt6.qt5compat
      pkgs.qt6.qtmultimedia
      pkgs.qt6.qtsvg
    ];
  };

  environment.systemPackages = [qylock-sddm-pkg];
}
