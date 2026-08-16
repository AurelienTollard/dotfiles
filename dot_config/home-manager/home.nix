{
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aurelient";
  home.homeDirectory = "/home/aurelient";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.jj
    pkgs.lazygit
    pkgs.bat
    pkgs.zoxide
    pkgs.bluetui
    pkgs.ripgrep
    pkgs.zellij

    pkgs.chezmoi
    pkgs.fish
    pkgs.starship

    pkgs.nautilus
    pkgs.pi-coding-agent
    pkgs.codex
    pkgs.zed-editor
    pkgs.alacritty
    pkgs.neovim
    pkgs.obsidian
    pkgs._1password-gui
    pkgs._1password-cli
    pkgs.google-chrome
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.papirus-icon-theme
    pkgs.signal-desktop

    pkgs.cargo
    pkgs.docker
    pkgs.pnpm
    pkgs.uv
    pkgs.nixd
    pkgs.nil
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      zed = "zeditor";
      hms = "home-manager switch";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.uv = {
    enable = true;

    python = {
      versions = [ "3.13" ];
      default = "3.13";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd" # Replaces the default 'cd' command with zoxide
    ];
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
