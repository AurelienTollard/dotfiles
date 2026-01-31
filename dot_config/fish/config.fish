# --- Detect WSL ---
if set -q WSL_DISTRO_NAME
    set -gx IS_WSL true
else
    set -gx IS_WSL false
end


# --- PATH setup ---

# Add all directories under ~/.local/bin
if test -d ~/.local/bin
    for dir in (find ~/.local/bin -type d 2>/dev/null)
        if not contains $dir $PATH
            set -gx PATH $PATH $dir
        end
    end
end

# Extra toolchains
set -gx PATH $PATH ~/.cargo/bin
set -gx PATH $PATH ~/.pixi/bin
set -gx PATH $PATH ~/.config/pixi/bin


# --- Default programs ---
set -gx EDITOR vi


# --- Colors ---
set -gx CLICOLOR 1
set -gx LSCOLORS gxfxcxdxbxegedabagacad


# --- XDG base directories ---
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME  $HOME/.cache
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx XDG_DATA_HOME   $HOME/.local/share


# --- Starship & Pixi ---
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/config.toml"
set -gx PIXI_HOME "$XDG_CONFIG_HOME/pixi"

if status is-interactive
	zoxide init fish | source
	starship init fish | source
	eval (zellij setup --generate-auto-start fish | string collect)
end
