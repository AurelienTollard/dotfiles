# fish + prompt + terminal tools (-> ~/.config/fish, starship, zellij, lazygit).
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellAliases = {
      c = "clear";

      # Safer coreutils
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      mkdir = "mkdir -pv";
      df = "df -h";
      rmrf = "rm -rf";

      # Colorized / nicer output
      ll = "ls -lAF1";
      dir = "ls -hN --color=auto --group-directories-first";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ip = "ip -color=auto";

      # Navigation
      bin = "cd ~/.local/bin";
      src = "cd ~/.local/src";
      config = "cd $XDG_CONFIG_HOME";
      cache = "cd $XDG_CACHE_HOME";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
  };

  # Prompt. Config is the raw TOML in dotfiles/starship.toml.
  programs.starship.enable = true;
  dotfiles.link."starship.toml" = "starship.toml";

  # Smarter `cd`: `cd foo` jumps to the most-used dir matching "foo", `cdi` picks interactively.
  # Plain paths (`cd ..`, `cd ~/x`) still work like normal cd.
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  # Terminal UI for git (provides the `lg` wrapper).
  programs.lazygit.enable = true;

  # Terminal multiplexer. Config is dotfiles/zellij/config.kdl.
  programs.zellij = {
    enable = true;
    # Don't auto-launch zellij in every fish shell; run `zellij` when you want it.
    enableFishIntegration = false;
  };
  dotfiles.link.zellij = "zellij";

  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;

  # Fuzzy finder: Ctrl-R history, Ctrl-T files, Alt-C dirs; also powers zoxide's `cdi`.
  programs.fzf.enable = true;
  home.packages = [ pkgs.bluetui ];
}
