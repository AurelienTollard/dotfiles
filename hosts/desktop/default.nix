# Main desktop: NVIDIA RTX 3060.
{
  hostname,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = hostname;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Default (LTS) kernel on purpose: the NVIDIA driver often lags behind
  # linuxPackages_latest and fails to build against it.

  nvidia.enable = true;
  gaming.enable = true;
  docker.enable = true;

  # First NixOS version installed on this machine. Never change it.
  # TODO: set to the value from the desktop's /etc/nixos/configuration.nix.
  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
