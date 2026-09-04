{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/programs/steam.nix
    ../../system/xdg.nix
    ../../system/environment.nix
    ../../system/packages.nix
    ../../system/setnix.nix
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 14 * 1024;
    }
  ];
  systemd = {
    services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
    user = {
      settings.Manager = {
        DefaultEnvironment = "AQ_DRM_DEVICES=/dev/dri/card1";
      };
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot = {
    supportedFilesystems = ["ntfs"];
    plymouth = {
      enable = true;
      theme = "mc";
      themePackages = [
        inputs.minecraft-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      font = "${inputs.minecraft-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default}/share/fonts/OTF/Minecraft.otf";
    };
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        splashImage = "${inputs.minegrub-world-sel-theme}/minegrub-world-selection/dirt.png";
        minegrub-world-sel = {
          enable = true;
          customIcons = with config.system; [
            {
              inherit name;
              lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
              lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;
              imgName = "nixos";
            }
          ];
        };
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd = {
      systemd.enable = true;
      kernelModules = ["amdgpu"];
    };
    kernelParams = [
      "quiet"
      "splash"
      "acpi_backlight=native"
      "nvidia-drm.modeset=1"

      # FORCE DYNAMIC POWER MANAGEMENT AT INITIALIZATION
      "nvidia.NVreg_DynamicPowerManagement=0x02"
      "nvidia.NVreg_DynamicPowerManagementVideoMemoryThreshold=0"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelPackages =
      inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest-lto-x86_64-v4;
    extraModprobeConfig = ''
      options nvidia NVreg_EnableBacklightHandler=1
      options rtw89pci disable_aspm_l1ss=y
      options nvidia NVreg_DynamicPowerManagement=0x02
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
      options nvidia NVreg_DynamicPowerManagementVideoMemoryThreshold=0
      options rtw89pci disable_aspm_l1=y
      options rtw89pci disable_aspm_l1ss=y
    '';
  };
  powerManagement = {
    enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit self inputs;};
    users.myriad = import ./home.nix;
    backupFileExtension = "backup";
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    acpilight.enable = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      dynamicBoost.enable = false;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    hostName = "nixos-myriad";
    networkmanager.enable = true;
  };

  programs = {
    gamemode.enable = true;
    zsh.enable = true;
    xfconf.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        libGL
        libglvnd
        qt6.qtbase
        glib
      ];
    };

    nh = {
      flake = "/home/myriad/nixos/";
    };

    nix-index-database.comma.enable = true;

    dconf.enable = true;
  };

  time.timeZone = "Asia/Kuala_Lumpur";

  users.users.myriad = {
    isNormalUser = true;
    description = "myriad";
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
      "disk"
      "input"
    ];
    shell = pkgs.zsh;
  };

  services = {
    envfs.enable = true;
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    udev.extraRules = ''
      ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"
      ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{power/control}="auto"
    '';

    asusd.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    xserver.videoDrivers = ["nvidia"];
    tumbler.enable = true;
    cardwired.enable = true;
    flatpak.enable = true;
  };
  security = {
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount" ||
             action.id == "org.freedesktop.udisks2.filesystem-mount-system") &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
    rtkit.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    inputs.minecraft-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "26.05";
}
