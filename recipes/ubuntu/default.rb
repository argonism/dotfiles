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

# Ubuntu 24.04 の apt 版は古いため、公式リリースのビルド済みバイナリを導入する。
github_binary 'tree-sitter' do
    repository 'tree-sitter/tree-sitter'
    version 'v0.26.11'
    archive 'tree-sitter-cli-linux-x64.zip'
    binary_path 'tree-sitter'
    bin_dir "#{ENV['HOME']}/.local/bin"
end

# Sheldon
execute "curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin" do
    not_if "which sheldon"
end

# atuin
execute "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh" do
    not_if "which atuin"
end

include_recipe 'python'
