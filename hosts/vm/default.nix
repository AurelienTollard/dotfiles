# QEMU test VM: the full desktop, for trying changes before switching a real machine.
#
#   nixos-rebuild build-vm --flake .#vm && ./result/bin/run-vm-vm    # throwaway, no install
#   nix run github:nix-community/nixos-anywhere -- --flake .#vm root@<ip>   # real install
{
  inputs,
  hostname,
  user,
  modulesPath,
  ...
}:
let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtEfUid+9RlaEkFBbmWOvlX/RIWislxnjzH3ZnJaZOK";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  networking.hostName = hostname;
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.graphics.enable = true;

  # Test machine: known password + SSH so it's reachable right after install.
  users.users.${user} = {
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [ sshKey ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ sshKey ];
  services.openssh.enable = true;

  # `build-vm`: give the VM enough resources for niri.
  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 4;
  };

  system.stateVersion = "26.05";
}
