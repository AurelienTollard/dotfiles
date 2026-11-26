# NixOS niri + DankMaterialShell desktop (pairs with modules/nixos/desktop/niri.nix).
{
  imports = [
    ./theme.nix
    ./audio.nix
    ./syncthing.nix
  ];

  # DMS writes into these at runtime (theme, bar, generated niri includes),
  # so they're linked live; changes show up in `git diff`.
  dotfiles.link = {
    niri = "niri";
    DankMaterialShell = "dms"; # DMS reads both names
    dms = "dms";
  };
}
