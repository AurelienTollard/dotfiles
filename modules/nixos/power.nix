# Power management: power-profiles-daemon (performance / balanced / power-saver).
# Switch with `powerprofilesctl set <profile>` or from the shell's UI.
{
  services.power-profiles-daemon.enable = true;

  # Battery / AC status over D-Bus. DMS (Quickshell) reads battery info only
  # through UPower, so without this the bar shows no battery.
  services.upower.enable = true;
}
