# System-level account for aurelient. Set the password with `passwd`.
{ pkgs, user, ... }:
{
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
    ];
  };
}
