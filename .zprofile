# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable/583502#583502
# Empty PATH setting for tmux MacOS users (tmux auto-prepends useless stuff)
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

# Set ZSH as default shell for M1 mac homebrew.
SHELL=/bin/zsh
# Zsh (installed via brew), will be installed in /opt/homebrew/bin/zsh.
# SHELL=/opt/homebrew/bin/zsh
