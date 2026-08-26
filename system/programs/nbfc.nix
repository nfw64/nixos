# nbfc.nix
{pkgs, ...}: let
  myUser = "myriad";
  command = "bin/nbfc_service --config-file '/home/${myUser}/.config/nbfc.json'";
in {
  environment.systemPackages = with pkgs; [
    nbfc-linux
  ];
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    path = [pkgs.kmod];
    serviceConfig = {
      Type = "simple";
      ExecStartPost = "${pkgs.nbfc-linux}/bin/nbfc set -s 30";
    };

    script = "${pkgs.nbfc-linux}/${command}";

    before = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
  };
}
