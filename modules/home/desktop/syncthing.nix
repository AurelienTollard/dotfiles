# Syncthing: syncs user *data* (notes, documents) between machines; Nix only syncs config.
# Web UI: http://127.0.0.1:8384
#
# Devices and folders are added in the web UI for now (override* = false keeps them).
# Once IDs are known (`syncthing --device-id`), they can be pinned here:
#   settings.devices.desktop.id = "XXXX-...";
#   settings.folders.notes = { path = "~/Notes"; devices = [ "book6" "desktop" ]; };
# and override* flipped to true so every machine converges on this file.
{
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };
}
