# Installing starship
curl -sS https://starship.rs/install.sh | sh

# Put the config file
ln -s "$PWD/starship/config.d/conf.toml" "$HOME/.config/starship.toml"
