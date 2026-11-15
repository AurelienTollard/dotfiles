# System side of fish: registers it in /etc/shells and installs vendor
# completions so it can be used as a login shell. User config lives in
# modules/home/shell.nix.
{
  programs.fish.enable = true;
}
