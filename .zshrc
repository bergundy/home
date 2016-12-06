ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cloud"
plugins=(git redis-cli zsh-syntax-highlighting docker supervisor docker-compose tmuxinator fabric)
fpath=(/usr/local/share/zsh-completions $fpath)

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

export EDITOR=vim

source ~/z/z.sh
