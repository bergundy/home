ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
plugins=(git redis-cli zsh-syntax-highlighting docker supervisor docker-compose tmuxinator fabric)
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

export EDITOR=vim
export GOPATH=$HOME/go
export GOROOT=$HOME/go
export PATH=~/bin:/usr/local/go/bin:${PATH}:${GOROOT}/bin

[ -e "$HOME/z/z.sh" ] && source $HOME/z/z.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
