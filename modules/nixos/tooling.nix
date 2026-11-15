# Tools for managing this flake-based system.
{ user, ... }:
{
  # Flakes need git to read the repo.
  programs.git.enable = true;

  # nh: nicer `nixos-rebuild` (shows a diff before switching) + automatic GC.
  programs.nh = {
    enable = true;
    flake = "/home/${user}/nixos-config";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };

  # Run generic (non-Nix) dynamically linked binaries, e.g. the claude-code
  # binary Claude Desktop downloads into ~/.config/Claude/claude-code/.
  programs.nix-ld.enable = true;

  # Hard-link identical files in the store to save space.
  nix.settings.auto-optimise-store = true;
}
