# Tailscale: private network between all machines (SSH, Syncthing, remote builds
# work from anywhere). One-time per machine: `sudo tailscale up`.
{
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
