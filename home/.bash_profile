LC_CTYPE=en_US.UTF-8
export LC_CTYPE

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

#
# PATH
#

PATH=$PATH:~/bin
#export PATH

DEVROOT=~/devroot
export DEVROOT

#
# Bash Completion
if hash brew 2>/dev/null; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
fi

#
# Java
#
if [ -f /usr/libexec/java_home ]; then
  JAVA_HOME=`/usr/libexec/java_home`
  export JAVA_HOME
fi

#
# Colorize the Terminal
#
export CLICOLOR=1;

#
# CDPATH - Add cdpath for easy directory nav
#
CDPATH=.:~:~/devroot
export CDPATH


#
# RBENV
#
PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"
export PATH

#
# EDITOR
#
vim1=/usr/local/bin/vim
vim2=/usr/bin/vim

if [ -f $vim1 ]; then
  export EDITOR=$vim1
else
  export EDITOR=$vim2
fi
