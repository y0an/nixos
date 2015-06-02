# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usbhid" "usb_storage" "hid_apple" "brcmfmac" ];
  boot.initrd.kernelModules = [ "hid_apple" ];
  boot.kernelModules = [ "kvm-intel" "bcm5974" "brcmfmac" "hid_apple" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device  = "/dev/disk/by-uuid/f3758d53-2e42-49b1-acd8-88a42d0fa66a";
      fsType  = "ext4";
      options = "defaults,noatime,discard";
      noCheck = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = 8;
  nix.extraOptions = ''
    build-cores = 8
  '';

}
