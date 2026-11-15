# Work laptop: non-NixOS Linux, standalone home-manager.
#   home-manager switch --flake ~/nixos-config#aurelient@work   (alias: hms)
{ pkgs, ... }:
{
  imports = [ ../../modules/home/apps ];

  # Things NixOS hosts get from the system config instead.
  home.packages = with pkgs; [
    _1password-gui
    _1password-cli
    docker
    papirus-icon-theme
  ];

  programs.home-manager.enable = true;
  programs.fish.shellAliases.hms = "home-manager switch --flake ~/nixos-config#aurelient@work -b bak";

  # Integrate with the host distro (XDG dirs, desktop entries, locales).
  targets.genericLinux.enable = true;
}
