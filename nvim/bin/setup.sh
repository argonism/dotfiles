#!/bin/bash
mkdir -p $HOME/.config/nvim/

CONFIG_DIR="$HOME/.config/nvim"

if [ -d $config_dir ]; then
  echo "nvim config directory already exists at $CONFIG_DIR"
  echo "resetting nvim config directory"
  rm -rf $CONFIG_DIR
fi

ln -s $HOME/dotfiles/nvim/config.d/ $CONFIG_DIR
