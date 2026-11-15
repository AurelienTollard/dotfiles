# GUI apps: usable on NixOS and on any Linux desktop (standalone home-manager).
{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./editor.nix
    ./browser.nix
    ./files.nix
    ./notes.nix
    ./media.nix
  ];

  # pkgs.claude-desktop comes from the claude-desktop overlay (see flake.nix).
  home.packages = [
    pkgs.claude-desktop
    pkgs.signal-desktop
    pkgs.nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.enable = true;
}
