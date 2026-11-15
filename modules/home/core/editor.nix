# Neovim; `vi` and `vim` are aliased to nvim.
# Config -> programs.neovim.initLua, plugins -> .plugins
{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets $EDITOR=nvim
    viAlias = true;
    vimAlias = true;
    initLua = ''
      vim.opt.clipboard = "unnamedplus"
    '';
  };
}
