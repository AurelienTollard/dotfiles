# Raw config files from ./dotfiles, linked *live* into ~/.config.
#
#   dotfiles.link.<name> = "<path under dotfiles/>";
#
# creates ~/.config/<name> -> ~/nixos-config/dotfiles/<path>. Because the link
# points at the git checkout (not the read-only Nix store), apps can save their
# own settings and edits show up immediately in `git diff`, no rebuild needed.
#
# This only works if the repo is checked out at `dotfiles.repoPath`, so the
# activation step below clones it there on a fresh machine.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    repoPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos-config";
      description = "Where the config repo is checked out.";
    };
    repoUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/AurelienTollard/dotfiles.git";
    };
    repoBranch = lib.mkOption {
      type = lib.types.str;
      default = "nix";
    };
    link = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "~/.config entry -> path under dotfiles/ in the repo.";
    };
  };

  config = {
    xdg.configFile = lib.mapAttrs (_: src: {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.repoPath}/dotfiles/${src}";
    }) cfg.link;

    # Fresh machine: make the symlink targets exist. Never fatal (may be offline).
    home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "${cfg.repoPath}/.git" ]; then
        run ${lib.getExe pkgs.git} clone --branch "${cfg.repoBranch}" \
          "${cfg.repoUrl}" "${cfg.repoPath}" \
          || warnEcho "could not clone ${cfg.repoUrl}; dotfile links are dangling until you clone it to ${cfg.repoPath}"
      fi
    '';
  };
}
