dotfile '.config/nvim'
dotfile '.config/karabiner'
dotfile '.config/sheldon'
dotfile '.gitconfig'
dotfile '.gitignore'
dotfile '.peco'
dotfile '.tmux.conf'
dotfile '.tmux.conf.local' => '.tmux.conf.darwin'
dotfile '.zsh'
dotfile '.zshrc'
dotfile '.zshrc.Linux'
dotfile '.starship.toml'

package 'curl'
package 'fzf'
package 'git'
package 'btop'
package 'tmux'
package 'xclip'

# Add repository for neovim
execute 'sudo add-apt-repository --yes --update ppa:neovim-ppa/stable' do
    not_if 'grep -r neovim-ppa /etc/apt/sources.list.d/'
end
package 'neovim'

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

include_recipe 'python'
