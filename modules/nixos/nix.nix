# Nix daemon and nixpkgs settings. Overlays are set in flake.nix (shared with home-manager).
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "@wheel" ]; # lets nixos-anywhere / remote builds push to the store

  nixpkgs.config.allowUnfree = true;
}
