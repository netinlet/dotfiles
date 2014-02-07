LC_CTYPE=en_US.UTF-8
export LC_CTYPE

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

LC_CTYPE=en_US.UTF-8
export LC_CTYPE

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

#
# PATH
#

PATH=$PATH:/usr/local/sbin:~/bin
#PATH=$PATH:/Users/doug/node_modules/.bin
PATH=$PATH:/usr/local/share/npm/bin
export PATH


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
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

#export NODE_PATH="/usr/local/share/npm/lib/node_modules"

export EDITOR=/usr/local/bin/mvim
