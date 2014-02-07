LC_CTYPE=en_US.UTF-8
export LC_CTYPE

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
