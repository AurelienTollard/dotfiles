# nixos-config

NixOS + home-manager configuration.

| Machine                 | Kind                           | Config                                                                      |
| ----------------------- | ------------------------------ | --------------------------------------------------------------------------- |
| Galaxy Book6 Pro laptop | NixOS                          | `nixosConfigurations.book6`                                                 |
| Desktop (RTX 3060)      | NixOS                          | `nixosConfigurations.desktop`                                               |
| Work laptop             | Linux, standalone home-manager | `homeConfigurations."aurelient@work"`                                       |
| Test VM                 | NixOS (QEMU)                   | `nixosConfigurations.vm`                                                    |

## Layout

| Path                     | What goes there                                                                 |
| ------------------------ | ------------------------------------------------------------------------------- |
| `flake.nix`              | Inputs, `mkHost` / `mkHome` helpers, every machine                              |
| `hosts/<hostname>/`      | Machine-specific: boot, hardware, disks (`disko.nix`), `stateVersion`           |
| `modules/nixos/`         | System modules shared by all NixOS hosts                                        |
| `modules/home/core/`     | CLI setup that works **everywhere** (fish, git, nvim, dev tools, dotfile links) |
| `modules/home/apps/`     | GUI apps for any Linux desktop (Zed, Alacritty, Chrome, Obsidian…)              |
| `modules/home/desktop/`  | NixOS-only niri + DankMaterialShell desktop, theme, audio, Syncthing            |
| `users/<user>/home.nix`  | home-manager base (imports `core`)                                              |
| `users/<user>/work.nix`  | Work-laptop additions (`apps` + non-NixOS bits)                                 |
| `users/<user>/nixos.nix` | System account                                                                  |
| `dotfiles/`              | Raw app config, linked **live** into `~/.config`                                |
| `secrets/`               | sops-encrypted secrets                                                          |

## Dotfiles

Configs that apps edit themselves (Zed, niri, DMS, Alacritty, zellij, starship, cava)
live as plain files in `dotfiles/` and are symlinked into `~/.config`, pointing at
this checkout rather than the Nix store:

```nix
dotfiles.link.zed = "zed";   # ~/.config/zed -> ~/nixos-config/dotfiles/zed
```

So changing a setting in the app (or editing the file) takes effect immediately and
shows up in `git diff`. Commit and push it, then `git pull` on the other machines. No rebuild needed.
This requires the repo to be at `~/nixos-config`, and a fresh machine clones it there on first activation.

Simpler configs are written in Nix instead (`programs.git`, fish aliases, …).

## Day to day

```sh
nh os switch            # NixOS: build, show diff, switch
hms                     # work laptop: home-manager switch
nh os test              # activate without adding a boot entry
nix flake update        # bump inputs (CI also opens a weekly PR)
nix fmt                 # format all .nix files
```

Sync between machines = `git pull` + switch. Everyone uses the same `flake.lock`,
so package versions match everywhere. CI (`.github/workflows/check.yml`) builds
`vm` and `aurelient@work` on every push.

## New machine in one line

**Non-NixOS (work laptop, any distro):**

```sh
curl -fsSL https://raw.githubusercontent.com/AurelienTollard/dotfiles/nix/bootstrap.sh | bash
```

Installs Nix, clones this repo to `~/nixos-config`, activates `aurelient@work`.

**Fresh NixOS install over SSH** (target booted on any NixOS ISO with root SSH access; **wipes the disk**):

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<host> \
  --generate-hardware-config nixos-facter hosts/<host>/facter.json \
  root@<ip>
```

The host needs a `disko.nix` (copy `hosts/vm/disko.nix`, fix `device`) and
`hardware.facter.reportPath = ./facter.json;` in its `default.nix`.

**Test VM, no install:**

```sh
nixos-rebuild build-vm --flake .#vm && ./result/bin/run-vm-vm   # login: aurelient / nixos
```

## Adding an existing NixOS machine

For a machine that already runs NixOS, like the desktop. Nothing is reformatted.

1. Clone the repo to `~/nixos-config`.
2. `mkdir hosts/<name>` and copy its `/etc/nixos/hardware-configuration.nix` there.
3. Write `hosts/<name>/default.nix` (see `hosts/book6`; keep that machine's original `system.stateVersion`).
4. Add `<name> = mkHost "<name>" "aurelient";` to `nixosConfigurations` in `flake.nix`.
5. `git add -A && sudo nixos-rebuild switch --flake .#<name>`

## Networking & data sync

- **Tailscale** on every NixOS host. Once per machine: `sudo tailscale up`.
- **Syncthing** (NixOS hosts) syncs data like notes and documents. Pair devices and
  folders in the web UI at http://127.0.0.1:8384; see `modules/home/desktop/syncthing.nix`
  to pin them declaratively later.

## Secrets

sops-nix with one personal age key.

```sh
# once: create the key and save keys.txt in 1Password
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
# put its public key (age1…) into .sops.yaml, then:
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

On each new machine, copy `keys.txt` from 1Password to `~/.config/sops/age/keys.txt`.
Use a secret from a NixOS module with `sops.secrets.<name> = { owner = user; };`.
It shows up at `/run/secrets/<name>`.

`secrets/work.yaml` holds the git work identity, decrypted by home-manager (see
`modules/home/core/git.nix`). The work laptop gets its own age key so it can't read
`secrets.yaml`: run `age-keygen -o ~/.config/sops/age/keys.txt` there, add its public
key as `&work` in `.sops.yaml` (uncomment the two lines), then on a machine with the
personal key run `sops updatekeys secrets/work.yaml` and commit. **Never commit `keys.txt` or plaintext secrets: this repo is public.**
