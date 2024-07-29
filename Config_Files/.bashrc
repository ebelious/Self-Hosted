#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


## ZSH oprions >> BASH
#
shopt -s autocd #auto cd - cd into a directory by just typing the directory name
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal


## File extractor
#
ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)    tar xjf $1    ;;
            *.tar.gz)     tar xzf $1    ;;
            *.bz2)        bunzip2 $1    ;;
            *.rar)        unrar x $1    ;;
            *.gz)         gunzip  $1    ;;
            *.tar)        tar xf  $1    ;;
            *.tbz2)       tar xjf $1    ;;
            *.tgz)        tar xzf $1    ;;
            *.zip)        unzip   $1    ;;
            *.Z)          uncompress $1 ;;
            *.7z)         7z x    $1    ;;
            *)            echo "'$1' can't be extracted via ex()"
        esac
    else
        echo "'$1' is not a valid file. Check spelling or file type."
    fi
}


## Aliases
#
alias uu='sudo dnf update'
alias l='lsd'
alias ll='lsd -l --group-directories-first'
alias la='lsd -al --group-directories-first'
alias cl='clear'
alias grep='grep --color=auto'
alias ca='highlight --out-format=ansi'
alias st='speedtest-cli'
alias gogh='bash -c  "$(wget -qO- https://git.io/vQgMr)"'
alias nano='nano -l'
alias gc='git clone'
#--Tools
alias msf='msfconsole -q'


## Git Repo Prompt
#
#parse_git_branch()
#{
#  git rev-parse --abbrev-ref head 2> /dev/null
#}

## Time on right column prompt
#
#rightprompt()
#{
#    printf "%*s" $COLUMNS "\[\e[0;32m[\e[0m\]$(date +%r)\[\e[0;32m]\e[0m\]"
#}
#export PS1="\[\n\]\[$(tput sc; rightprompt; tput rc)\]\[\e[2;36m\]\[\w\]\[\e[0m\]\[\n\]\[\e[0;32m[\]\[\e[0m\]\[\e[1;36m>\]\[\e[0m\]\[\e[0;32m]\]\[\e[0m\]\]\] "

## Basic prompt                                                                                                                                                                                                                           │#                                                                                                                                                                                                                                         │
export PS1="\[\n\]\[\e[2;36m\]\[\w\]\[\e[0m\]\[\n\]\[\e[0;32m[\]\[\e[0m\]\[\e[1;36m>\]\[\e[0m\]\[\e[0;32m]\]\[\e[0m\]\]\] "  


## pyenv variable
#
#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"

## Start Zellij on Launch
eval "$(zellij setup --generate-auto-start bash)"

## fastfetch header
#
fastfetch -l none

# These are the Command-Center aliases
alias sqlmap='python ~/Command-Center/sqlmap-dev/sqlmap.py'
alias ccenter='~/Command-Center/command-center.sh'
alias responder='python2.7 ~/Command-Center/Responder/Responder.py'
alias ttyper='/home/eric@home.local/.cargo/bin/ttyper'
