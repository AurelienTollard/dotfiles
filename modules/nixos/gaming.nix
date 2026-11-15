# Gaming. Steam must be system-level: the NixOS module enables 32-bit graphics
# drivers, controller udev rules and the FHS runtime Steam games expect.
# Opt in per host with `gaming.enable = true;`.
#
# Per-game Steam launch options, combine as needed:
#   gamemoderun %command%                 CPU governor/priority boost (GameMode)
#   mangohud %command%                    FPS / frametime / temps overlay
#   gamescope -f -- %command%             run inside Gamescope (fullscreen fixes, FSR, FPS cap)
# Proton-GE shows up in Steam under Properties > Compatibility.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.gaming.enable = lib.mkEnableOption "gaming (Steam)";

  config = lib.mkIf config.gaming.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    programs.gamemode.enable = true;

    # No capSysNice: that installs a setcap wrapper which can't run inside
    # Steam's sandbox (no_new_privs), so gamescope exits with
    # "failed to inherit capabilities" when used as a launch option.
    programs.gamescope.enable = true;

    environment.systemPackages = [ pkgs.mangohud ];
  };
}
