dotfile '.config/nvim'
dotfile '.config/karabiner'
dotfile '.config/sheldon'
dotfile '.config/herdr/config.toml'
dotfile '.gitconfig'
dotfile '.gitignore'
dotfile '.peco'
dotfile '.tmux.conf'
dotfile '.tmux.conf.local' => '.tmux.conf.darwin'
dotfile '.zsh'
dotfile '.zshrc'
dotfile '.zshrc.darwin'
dotfile '.starship.toml'

package 'git'

include_recipe 'gpg-agent'
include_recipe 'brew'

# starship
execute "curl -sS https://starship.rs/install.sh | sh -s -- -y" do
    not_if 'which starship'
end

# rustup
execute "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" do
    not_if 'which rustc'
end

# Sheldon
execute "curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin" do
    not_if "which sheldon"
end
