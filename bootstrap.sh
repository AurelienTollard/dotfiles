#!/usr/bin/env bash
# One-line setup for a non-NixOS machine (standalone home-manager):
#
#   curl -fsSL https://raw.githubusercontent.com/AurelienTollard/dotfiles/nix/bootstrap.sh | bash
#
# Override with env vars: CONFIG=aurelient@work BRANCH=nix DEST=~/nixos-config
set -euo pipefail

REPO="${REPO:-https://github.com/AurelienTollard/dotfiles.git}"
BRANCH="${BRANCH:-nix}"
DEST="${DEST:-$HOME/nixos-config}"
CONFIG="${CONFIG:-aurelient@work}"

log() { printf '\n==> %s\n' "$*"; }
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[[ "$(id -u)" -ne 0 ]] || fail "run as your normal user, not root"
command -v curl >/dev/null || fail "curl is required"

load_nix() {
  for p in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
           "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    # shellcheck disable=SC1090
    [[ -r "$p" ]] && . "$p"
  done
  return 0
}

load_nix
if ! command -v nix >/dev/null; then
  log "Installing Nix"
  curl -fsSL https://nixos.org/nix/install | sh -s -- --daemon --yes
  load_nix
fi
command -v nix >/dev/null || fail "Nix installed but not on PATH; open a new shell and re-run"

NIX=(nix --extra-experimental-features "nix-command flakes")

if [[ -d "$DEST/.git" ]]; then
  log "Updating $DEST"
  git -C "$DEST" pull --ff-only || true
else
  log "Cloning $REPO ($BRANCH) to $DEST"
  "${NIX[@]}" shell nixpkgs#git -c git clone --branch "$BRANCH" "$REPO" "$DEST"
fi

log "Activating home-manager config $CONFIG"
"${NIX[@]}" run home-manager/master -- switch --flake "$DEST#$CONFIG" -b bak

log "Done. Open a new shell. Later updates: git -C $DEST pull && hms"
