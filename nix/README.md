# macOS configuration with nix-darwin

This directory manages macOS settings with nix-darwin. Homebrew packages and
dotfiles remain managed by the existing mitamae recipes, so the two systems do
not compete over the same files.

## Local configuration

Create the machine-local configuration before evaluating the flake:

```sh
cd ~/Project/dotfiles/nix
cp local.nix.example local.nix
```

Set `username` in `local.nix` to the existing macOS account name. This file is
excluded from Git so each Mac can use its own account. Keep using the explicit
`path:.` flake reference so the ignored local file is included in evaluation.

## Validate

```sh
cd ~/Project/dotfiles/nix
nix flake check --no-build path:.
```

## First activation

Review `darwin-configuration.nix`, then bootstrap nix-darwin:

```sh
cd ~/Project/dotfiles/nix
sudo nix run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake path:.#Kota-UsuhaMacBook-Pro
```

The first activation installs `darwin-rebuild`. Later changes can be applied
with:

```sh
cd ~/Project/dotfiles/nix
sudo darwin-rebuild switch --flake path:.#Kota-UsuhaMacBook-Pro
```

Some UI preferences only become visible after reopening the affected app or
logging out and back in.

## Roll back

If an activation causes a problem, inspect the system generations and activate
the previous one:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild --rollback
```

## Update pinned inputs

```sh
cd ~/Project/dotfiles/nix
nix flake update
nix flake check --no-build path:.
sudo darwin-rebuild switch --flake path:.#Kota-UsuhaMacBook-Pro
```

Keep `system.stateVersion` at `7` when updating. It records the compatibility
version used for the first activation and is not the macOS release number.
