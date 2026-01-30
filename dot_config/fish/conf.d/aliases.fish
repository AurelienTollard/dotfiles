# Clear
alias c='clear'

# Safer coreutils
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -vI'
alias mkdir='mkdir -pv'
alias df='df -h'

# Colorized / nicer output
alias ll='ls -lAF1'
alias dir='ls -hN --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# Navigation
alias bin='cd ~/.local/bin'
alias src='cd ~/.local/src'
alias config='cd $XDG_CONFIG_HOME'
alias cache='cd $XDG_CACHE_HOME'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Misc
alias rmrf='rm -rf'
alias lg='lazygit'

# Replace cd with z (assuming zoxide)
alias cd='z'

if set -q WSL_DISTRO_NAME
    function pwsh
        if test (count $argv) -eq 0
            echo "No command provided."
            return 1
        end

        pwsh.exe -Command (string join ' ' $argv)
    end
end

