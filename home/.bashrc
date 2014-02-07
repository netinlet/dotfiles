source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
export PS1

alias rc='bundle exec rails console'
alias rs='bundle exec rails server thin'
alias be='bundle exec $@'
alias geminfo='gem env gemdir'

#All commands have been installed with the prefix 'g'.
#A file that aliases these commands to their normal names is available
#and may be used in your bashrc like:

#    source /usr/local/Cellar/coreutils/8.12/aliases

#But note that sourcing these aliases will cause them to be used instead
#of Bash built-in commands, which may cause problems in shell scripts.
#The Bash "printf" built-in behaves differently than gprintf, for instance,
#which is known to cause problems with "bash-completion".

# Generate a 12 character random password
alias pw="gtr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | fold -w 12 | head -n 1"

HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=1000000000

export HISTCONTROL
export HISTSIZE
export HISTFILESIZE

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ARCHFLAGS="-arch x86_64"

#ssh-add > /dev/null 2>&1

