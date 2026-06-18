{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = [
    (pkgs.buildGoModule {
      pname = "kari";
      version = "latest";
      src = inputs.kari;

      subPackages = ["cmd/kari"];

      vendorHash = "sha256-a//13YOUpG3+IMT8X6Lt4z0ceMOJe9D/Mad4QnnN6Ts=";

      nativeBuildInputs = [pkgs.makeWrapper];

      postInstall = ''
        wrapProgram $out/bin/kari \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.aria2
          pkgs.mpv
          pkgs.python313Packages.yt-dlp
        ]}
      '';

      meta = {
        description = "Kari — hunt media from the terminal";
        homepage = "https://github.com/Dhairya3391/kari";
        mainProgram = "kari";
      };
    })
  ];
}
