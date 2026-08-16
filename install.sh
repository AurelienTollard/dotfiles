#!/usr/bin/env bash
set -euo pipefail

HOME_MANAGER_CHANNEL="${HOME_MANAGER_CHANNEL:-master}"
NIX_INSTALLER_URL="https://nixos.org/nix/install"
CHEZMOI_REPO="${CHEZMOI_REPO:-https://github.com/AurelienTollard/dotfiles.git}"
CHEZMOI_SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/chezmoi}"

log() {
  printf '\n==> %s\n' "$*"
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  fail "run this script as your normal user, not root"
fi

if ! command -v curl >/dev/null 2>&1; then
  fail "curl is required"
fi

load_nix() {
  local profile
  local profiles=(
    "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  )

  for profile in "${profiles[@]}"; do
    if [[ -r "$profile" ]]; then
      # shellcheck disable=SC1090
      . "$profile"
    fi
  done
}

if command -v nix >/dev/null 2>&1; then
  log "Nix is already installed"
else
  log "Installing Nix"
  curl --fail --location --proto '=https' --tlsv1.2 "$NIX_INSTALLER_URL" | sh -s -- --daemon
fi

load_nix
command -v nix >/dev/null 2>&1 || fail "Nix was installed, but is not available in this shell"
command -v nix-channel >/dev/null 2>&1 || fail "nix-channel is not available in this shell"
command -v nix-shell >/dev/null 2>&1 || fail "nix-shell is not available in this shell"

if [[ -e "${CHEZMOI_SOURCE_DIR}/.git" ]]; then
  log "Dotfiles are already initialized at ${CHEZMOI_SOURCE_DIR}"
elif [[ -e "$CHEZMOI_SOURCE_DIR" ]]; then
  fail "${CHEZMOI_SOURCE_DIR} already exists but is not a Git checkout"
else
  log "Initializing dotfiles from ${CHEZMOI_REPO}"
  CHEZMOI_REPO="$CHEZMOI_REPO" nix-shell -p chezmoi --run \
    'exec chezmoi init --apply "$CHEZMOI_REPO"'
fi

if command -v home-manager >/dev/null 2>&1; then
  log "Home Manager is already installed"
else
  log "Installing Home Manager (${HOME_MANAGER_CHANNEL})"
  nix-channel --add \
    "https://github.com/nix-community/home-manager/archive/${HOME_MANAGER_CHANNEL}.tar.gz" \
    home-manager
  nix-channel --update home-manager
  nix-shell '<home-manager>' -A install
fi

log "Setup complete"
printf 'Open a new shell before using home-manager.\n'
