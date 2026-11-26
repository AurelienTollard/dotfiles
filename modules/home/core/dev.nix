# Language toolchains and coding agents.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    pnpm
    nixd
    nil
    sops # edit secrets/: sops secrets/secrets.yaml
    age
    lazydocker
  ];

  programs.uv = {
    enable = true;
    python = {
      versions = [ "3.13" ];
      default = "3.13";
    };
  };
}
