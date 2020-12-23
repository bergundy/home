ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
plugins=(zsh-syntax-highlighting fzf git redis-cli docker supervisor docker-compose tmuxinator fabric)
fpath=($HOME/gcloud-zsh-completion/src $fpath)

source $ZSH/oh-my-zsh.sh
[ -e "$HOME/.zshrc.local" ] && source $HOME/.zshrc.local

bindkey -e
unsetopt share_history
setopt print_exit_value

function yalla {
    perl -i -n -e "print unless (\$. == $1)" ~/.ssh/known_hosts;
}

kill_word() {
    local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/:'
    zle backward-kill-word
}

zle -N kill_word
bindkey "\C-w" kill_word
WORDCHARS='_'

alias activate="source .pyenv/bin/activate"
alias unix2date="perl -e 'print scalar localtime \$ARGV[0]'"
alias ipof="ec2 ls -f private_ip"
alias vi=vim
alias gfrb='git fetch && git rebase $(git rev-parse --abbrev-ref origin/HEAD -- 2> /dev/null || echo origin/master)'
alias gcor='git recent | fzf | xargs git checkout'

export LC_ALL=en_US.UTF-8
export EDITOR=vim
export GOPATH=$HOME/go
export PATH=~/bin:${GOPATH}/bin:${PATH}

[ -e "$HOME/z/z.sh" ] && source $HOME/z/z.sh
if which exa &> /dev/null; then
    alias ls=exa
    alias ll='exa --long --git'
fi

export NVM_DIR="$HOME/.nvm"
nvm() {
    echo "🚨 NVM not loaded! Loading now..."
    unset -f nvm
    export NVM_PREFIX=$(brew --prefix nvm)
    [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
    nvm "$@"
}

export PATH="$HOME/.local/bin:$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# WSL (Windows Subsystem for Linux) specific settings.
if grep -qE "(microsoft|WSL)" /proc/version &>/dev/null; then
    # Adjustments for WSL's file / folder permission metadata.
    if [ "$(umask)" = "0000" ]; then
        umask 0022
    fi
    # Access local X-server with VcXsrv.
    # Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
    export DISPLAY=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf):0
fi
