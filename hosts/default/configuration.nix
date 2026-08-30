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
    ../../system/programs/ghelper.nix
    ../../system/programs/qylock.nix
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 14 * 1024;
    }
  ];

  systemd.user = {
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

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = false;
      dynamicBoost.enable = true;
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

  networking.hostName = "nixos-myriad";
  networking.networkmanager.enable = true;

  programs = {
    gamemode.enable = true;
    zsh.enable = true;
    xfconf.enable = true;
    niri.enable = true;

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
      "wheel"
      "disk"
      "input"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
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
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
    '';

    asusd.enable = true;
    dbus.implementation = "broker";
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
