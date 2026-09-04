{pkgs, ...}: {
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraProfile = ''
        export __NV_PRIME_RENDER_OFFLOAD=0
      '';
    };
  };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
  ];

  environment.systemPackages = with pkgs; [
    usbutils
    pkgs.libsndfile
    pkgs.xwayland
    gamescope
  ];
}
