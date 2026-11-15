# NVIDIA proprietary driver (Wayland / niri). Opt in per host with `nvidia.enable = true;`.
# Assumes a Turing or newer GPU (RTX 20xx+), which can use the open kernel modules.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nvidia.enable = lib.mkEnableOption "the NVIDIA proprietary driver";

  config = lib.mkIf config.nvidia.enable {
    hardware.graphics.enable = true;

    # Also selects the driver on Wayland-only setups, despite the name.
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true; # open kernel modules: recommended for Turing+
      modesetting.enable = true; # required by Wayland compositors
      powerManagement.enable = true; # save VRAM on suspend, avoids corruption on resume
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Hardware video decoding (VA-API) in Firefox, mpv, …
    hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    # niri on NVIDIA: without this the driver keeps a huge free-buffer pool and
    # niri can use ~1 GiB of VRAM. From the niri wiki ("Nvidia").
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      builtins.toJSON {
        rules = [
          {
            pattern = {
              feature = "procname";
              matches = "niri";
            };
            profile = "Limit Free Buffer Pool On Wayland Compositors";
          }
        ];
        profiles = [
          {
            name = "Limit Free Buffer Pool On Wayland Compositors";
            settings = [
              {
                key = "GLVidHeapReuseRatio";
                value = 0;
              }
            ];
          }
        ];
      };
  };
}
