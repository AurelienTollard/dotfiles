# Zed. Config is dotfiles/zed (settings.json, keymap.json, themes), linked live,
# so changes made from inside Zed land straight in the repo. `zed` is aliased to zeditor.
{
  programs.zed-editor.enable = true;
  programs.fish.shellAliases.zed = "zeditor";
  dotfiles.link.zed = "zed";
}
