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
    ../../system/programs/nbfc.nix
    ../../system/programs/qylock.nix
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 14 * 1024;
    }
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
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
      kernelModules = ["i915"];
      systemd.enable = true;
    };
    kernelParams = [
      "i915.enable_psr=0"
      "intel_pstate=active"
      "quiet"
      "splash"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelPackages =
      inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest-lto-x86_64-v4;
  };
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
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

    graphics = {
      enable = true;
      enable32Bit = true; # Crucial for 32-bit Wine and Steam games

      extraPackages = with pkgs; [
        intel-media-driver # Main VA-API driver for hardware video decoding
        vpl-gpu-rt # Intel oneVPL runtime for Quick Sync video (QSV)
        intel-compute-runtime # OpenCL/Level Zero computing (Blender, DaVinci Resolve)
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver # 32-bit hardware decoding for old apps/Steam
      ];
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
    dbus.implementation = "broker";

    upower.enable = true;
    udisks2.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
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
