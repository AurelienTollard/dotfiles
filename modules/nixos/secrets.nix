# sops-nix: encrypted secrets committed to the repo, decrypted at activation.
#
# Decryption key: a personal age key at ~/.config/sops/age/keys.txt (keep a copy
# in 1Password; copy it onto each new machine). Setup and usage: README "Secrets".
#
# Declare a secret (it appears at /run/secrets/<name>):
#   sops.secrets.example = { owner = user; };
{
  inputs,
  user,
  lib,
  ...
}:
let
  secretsFile = ../../secrets/secrets.yaml;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = lib.mkIf (builtins.pathExists secretsFile) secretsFile;
  };
}
