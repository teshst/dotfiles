!#/bin/bash

# Clone Git Repo
git clone --bare git@github.com:teshst/dotfiles.git $HOME/.cfg

# Temp Alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# RM Existing Files
rm $HOME/.bashrc
rm $HOME/.zshrc
rm $HOME/.config/nvm
rm $HOME/.config/kitty
rm $HOME/.config/zsh

# Load Files
config checkout

# Dont Track UnTracked files
config config --local status.showUntrackedFiles no
