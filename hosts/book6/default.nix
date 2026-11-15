# Galaxy Book6 Pro laptop.
{
  pkgs,
  hostname,
  inputs,
  user,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.sc200pc.nixosModules.default
  ];

  networking.hostName = hostname;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;

  # Intel Panther Lake (xe driver): PSR2 / Panel Replay selective update causes
  # white-line artifacts ("Selective fetch area calculation failed in pipe A").
  # Disable PSR and Panel Replay entirely. Do NOT use xe.enable_psr2_sel_fetch=0:
  # the driver flags it as dangerous and it gave a black screen on this panel.
  boot.kernelParams = [
    "xe.enable_psr=0"
    "xe.enable_panel_replay=0"
  ];

  # Galaxy Book6 Pro front camera (SC200PC sensor, ACPI SSLC2000, Intel IPU7).
  hardware.sc200pc.enable = true;

  gaming.enable = true;
  docker.enable = true;

  # Galaxy Book6 Pro speakers: EasyEffects EQ/bass/limiter preset (modules/home/audio.nix).
  home-manager.users.${user}.galaxybook.speakers.enable = true;

  # First NixOS version installed on this machine. Never change it.
  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
