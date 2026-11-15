# Niri compositor + DankMaterialShell + DMS greeter.
{ pkgs, ... }:
{
  programs.niri.enable = true;

  # X11 apps (Steam, games, some Electron apps). Niri has no built-in Xwayland:
  # it spawns xwayland-satellite on demand when it's in PATH and sets DISPLAY.
  # wl-mirror: screen mirroring for presenting (Mod+Shift+C).
  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.wl-mirror
  ];

  programs.dux-shell = {
    enable = true;
    systemd.enable = true;
  };

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # Trash, removable drives and network locations in Nautilus (outside GNOME).
  services.gvfs.enable = true;
}
