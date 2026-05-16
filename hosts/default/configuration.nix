{
  config,
  pkgs,
  inputs,
  self,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/system/programs/steam.nix"
    "${self}/system/xdg.nix"
    "${self}/system/environment.nix"
    "${self}/system/packages.nix"
    "${self}/system/setnix.nix"
    "${self}/system/programs/nbfc.nix"
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 14 * 1024;
    }
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
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
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
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
      kernelModules = [ "i915" ];
      systemd.enable = true;
    };
    kernelParams = [
      "i915.enable_psr=0"
      "intel_pstate=active"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;

      "vm.vfs_cache_pressure" = 50;

      "kernel.sched_latency_ns" = 10000000;
      "kernel.sched_min_granularity_ns" = 1000000;
      "kernel.sched_wakeup_granularity_ns" = 2000000;
      "kernel.sched_migration_cost_ns" = 500000;
    };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;
  };
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
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
    nm-applet.enable = true;
    zsh.enable = true;
    xfconf.enable = true;
    niri.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glib
        libX11
        libXext
        libXrender
        libXi
        libXtst
        libglvnd
        alsa-lib
      ];
    };

    nh = {
      flake = "/home/myriad/nixos/";
    };
    dconf.enable = true;
  };

  time.timeZone = "Asia/Kuala_Lumpur";

  users.users.myriad = {
    isNormalUser = true;
    description = "myriad";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    envfs.enable = true;
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
            otherlayer = { };
          };
        };
      };
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
          user = "greeter";
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
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };
  security = {
    rtkit.enable = true;
    pam.services.swaylock = { };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  system.stateVersion = "25.11";

}
