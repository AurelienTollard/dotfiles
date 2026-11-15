# home-manager base for aurelient, shared by every machine.
# NixOS hosts add ../../modules/home/{apps,desktop} (see mkHost in flake.nix);
# the work laptop adds ./work.nix.
{ user, ... }:
{
  imports = [ ../../modules/home/core ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "26.05"; # same as system.stateVersion; never change
}
