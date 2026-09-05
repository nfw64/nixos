{
  config,
  pkgs,
  ...
}: let
  qemuHook = pkgs.writeShellScript "qemu-hook" ''
    # Enable debugging logs to /var/log/libvirt/qemu-hook.log if troubleshooting is needed
    exec 2>>/var/log/libvirt/qemu-hook.log
    set -x

    VIRSH_GPU_PCI="0000:01:00.0"
    VIRSH_AUDIO_PCI="0000:01:00.1"

    OBJECT=$1
    OPERATION=$2

    # Match your VM name (case-insensitive or explicit names)
    if [[ "$OBJECT" =~ ^(win10|win11)$ ]]; then
        case "$OPERATION" in
            prepare)
                # 1. Wake the GPU out of its current D3cold power state to prevent kernel panic
                echo "on" > /sys/bus/pci/devices/$VIRSH_GPU_PCI/power/control
                echo "on" > /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/power/control
                sleep 1

                # 2. Unbind the GPU and Audio function from native host drivers
                if [ -e /sys/bus/pci/devices/$VIRSH_GPU_PCI/driver ]; then
                    echo "$VIRSH_GPU_PCI" > /sys/bus/pci/devices/$VIRSH_GPU_PCI/driver/unbind
                fi
                if [ -e /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/driver ]; then
                    echo "$VIRSH_AUDIO_PCI" > /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/driver/unbind
                fi

                # 3. Apply driver override to target vfio-pci
                echo "vfio-pci" > /sys/bus/pci/devices/$VIRSH_GPU_PCI/driver_override
                echo "vfio-pci" > /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/driver_override

                # 4. Bind both components directly to VFIO isolation
                echo "$VIRSH_GPU_PCI" > /sys/bus/pci/drivers/vfio-pci/bind
                echo "$VIRSH_AUDIO_PCI" > /sys/bus/pci/drivers/vfio-pci/bind
                ;;

            release)
                # 1. Unbind the card functions from the virtual machine framework
                echo "$VIRSH_GPU_PCI" > /sys/bus/pci/drivers/vfio-pci/unbind
                echo "$VIRSH_AUDIO_PCI" > /sys/bus/pci/drivers/vfio-pci/unbind

                # 2. Clear out driver overrides
                echo "" > /sys/bus/pci/devices/$VIRSH_GPU_PCI/driver_override
                echo "" > /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/driver_override

                # 3. Re-attach the hardware nodes back to native NVIDIA host drivers
                echo "$VIRSH_GPU_PCI" > /sys/bus/pci/drivers/nvidia/bind
                echo "$VIRSH_AUDIO_PCI" > /sys/bus/pci/drivers/snd_hda_intel/bind

                # 4. Restore automatic power management state allowing GPU to hit d3cold
                echo "auto" > /sys/bus/pci/devices/$VIRSH_GPU_PCI/power/control
                echo "auto" > /sys/bus/pci/devices/$VIRSH_AUDIO_PCI/power/control
                ;;
        esac
    fi
  '';
in {
  systemd.user.services.libvirt-nosleep = {
    description = "Preventing sleep while libvirt domain '%i' is running";
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/systemd-inhibit --what=sleep --why='Libvirt domain \"%i\" is running' --who=%U --mode=block sleep infinity";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  programs.virt-manager.enable = true;

  # Create state directory and symlink executable hook into /var/lib/libvirt/hooks/qemu
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/hooks 0755 root root -"
    "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuHook}"
  ];
}
