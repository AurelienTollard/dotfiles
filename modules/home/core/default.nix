# CLI environment: works on NixOS and on any Linux running standalone home-manager.
{
  imports = [
    ./dotfiles.nix
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./dev.nix
    ./claude.nix
  ];
}
