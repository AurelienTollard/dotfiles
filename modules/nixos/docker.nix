# Docker (includes the `docker compose` plugin). Opt in per host with `docker.enable = true;`.
# The user joins the `docker` group: no sudo needed, but that is root-equivalent.
# Group membership applies after logging out and back in.
#
# On NVIDIA hosts, GPUs are exposed through CDI:
#   docker run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi
{
  config,
  lib,
  user,
  ...
}:
{
  options.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.docker.enable {
    virtualisation.docker = {
      enable = true;
      # Weekly `docker system prune` so images and build cache don't fill the disk.
      autoPrune.enable = true;
      daemon.settings.features.cdi = true;
    };

    hardware.nvidia-container-toolkit.enable = config.nvidia.enable;

    users.users.${user}.extraGroups = [ "docker" ];
  };
}
