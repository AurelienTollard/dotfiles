# Desktop theming: icon theme (GTK + dconf for libadwaita/GTK4 apps).
{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark"; # or "Papirus" / "Papirus-Light"
      package = pkgs.papirus-icon-theme;
    };
  };
}
