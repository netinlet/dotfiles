# Command aliases, sourced by ~/.bashrc.

# Color support.
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Directory listings.
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Random password text.
alias getpass='openssl rand -base64 32'
