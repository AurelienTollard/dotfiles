# Language toolchains and coding agents.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    pnpm
    nixd
    nil
    codex
    pi-coding-agent
    sops # edit secrets/: sops secrets/secrets.yaml
    age
    lazydocker # TUI for containers, logs and compose stacks
  ];

  programs.uv = {
    enable = true;
    python = {
      versions = [ "3.13" ];
      default = "3.13";
    };
  };
}
