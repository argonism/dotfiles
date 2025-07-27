#!/bin/bash
mkdir -p $HOME/.config/nvim

config_dir="$home/.config/nvim"

if [ -d $config_dir ]; then
  echo "nvim config directory already exists at $config_dir"
  echo "resetting nvim config directory"
  rm -rf $config_dir
fi

ln -s $home/dotfiles/nvim/config.d/ $config_dir
