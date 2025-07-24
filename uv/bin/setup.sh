#!/bin/bash
if which uv >/dev/null; then
  echo "uv is already installed"
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi


mkdir -p $HOME/.config/uv

ln -s $HOME/dotfiles/uv/config.d/uv.toml $HOME/.config/uv
