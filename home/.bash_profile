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


#
# Bash Completion

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

#
# Java
#
JAVA_HOME=`/usr/libexec/java_home`
export JAVA_HOME

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


export EDITOR=/usr/local/bin/vim
