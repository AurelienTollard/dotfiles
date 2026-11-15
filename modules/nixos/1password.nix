# 1Password (CLI + GUI). Must be system-level: the NixOS module installs the
# polkit policy (system authentication unlock) and the setgid helper used for
# CLI and browser-extension integration, which home-manager cannot provide.
{ user, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user ];
  };
}
