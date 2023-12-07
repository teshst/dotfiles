{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=3G" "mode=755"];
      neededForBoot = true;
    };

  fileSystems."/home/${config.user.name}" =
    { device = "none";
      fsType = "tmpfs";
      options = ["size=4G" "mode=777"];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1FF4-40EE";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd" "subvol=nix" ];
      neededForBoot = true;
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/f638986c-e05c-4950-a35e-2f2cc6a0a9ec";

  fileSystems."/persist" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd" "subvol=persist" ];
      neededForBoot = true;
    };

  fileSystems."/etc/dotfiles" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd"  "subvol=dotfiles" ];
    };

  fileSystems."/swap" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd"  "subvol=swap" ];
      neededForBoot = true;
    };

  swapDevices = [{ device = "/swap/swapfile"; }];


  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.amd.updateMicrocode = true;
}

