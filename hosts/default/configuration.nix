{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/programs/steam.nix
    ../../system/xdg.nix
    ../../system/environment.nix
    ../../system/packages.nix
    ../../system/setnix.nix
    ../../system/programs/qemu.nix
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
      services.hyprpolkitagent = {
        description = "Hyprpolkitagent - Polkit authentication agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
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

      # Aggressive PCIe ASPM Power Savings (Fixes baseline bus drain)
      "pcie_aspm=force"
      "pcie_aspm.policy=powersupersave"

      # Force Dynamic Power Management for RTX 3050
      "nvidia.NVreg_DynamicPowerManagement=0x02"
      "nvidia.NVreg_DynamicPowerManagementVideoMemoryThreshold=0"
      "nvidia.NVreg_EnableS0ixPowerManagement=1"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelPackages =
      inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest-lto-x86_64-v4;
    extraModprobeConfig = ''
      options nvidia Nvreg_EnableGpuFirmware=0
      options nvidia NVreg_EnableBacklightHandler=1
      options nvidia NVreg_PreserveVideoMemoryAllocations=0
      options rtw89pci disable_aspm_l1=n
      options rtw89pci disable_aspm_l1ss=n
    '';
  };

  powerManagement.enable = true;

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
    transmission = {
      enable = true;
      openFirewall = true;
      openRPCPort = true;
      settings = {
        download-dir = "/home/myriad/Downloads";
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "127.0.0.1";
      };
    };
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
      # Force PM auto for Nvidia Audio Controller (0x040300)
      ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto"
      ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"
      ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{power/control}="auto"

      # Unbind dGPU and Audio controller on Battery power
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo 0000:01:00.1 > /sys/bus/pci/drivers/snd_hda_intel/unbind; echo 0000:01:00.0 > /sys/bus/pci/drivers/nvidia/unbind'"

      # Rebind dGPU and Audio controller on AC power
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo 0000:01:00.0 > /sys/bus/pci/drivers_probe; echo 0000:01:00.1 > /sys/bus/pci/drivers_probe'"
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
    cardwired = {
      enable = true;
      settings = {
        battery_auto_switch = false;
        battery_auto_switch_mode = "smart";
        auto_apply_gpu_state = true;
        experimental_nvidia_block = true;
      };
    };

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
