!#/bin/bash

# RM Existing Files
rm $HOME/.bashrc
rm $HOME/.zshrc
rm -rf $HOME/.config/nvm
rm -rf $HOME/.config/kitty
rm -rf $HOME/.config/zsh

# Clone Git Repo
git clone --bare git@github.com:teshst/dotfiles.git $HOME/.cfg

# Temp Alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Load Files
config checkout

# Dont Track UnTracked files
config config --local status.showUntrackedFiles no
