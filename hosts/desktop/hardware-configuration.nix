# PLACEHOLDER: replace this whole file with the desktop's own
# /etc/nixos/hardware-configuration.nix before switching.
# The mounts below assume the NixOS manual's partition labels (nixos / boot)
# and exist only so the flake evaluates.
{
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  warnings = [
    "hosts/desktop/hardware-configuration.nix is a placeholder: copy the real one from the desktop."
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
