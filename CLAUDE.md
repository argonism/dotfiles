# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common commands

```sh
./install.sh -n        # dry-run the full provisioning
./install.sh           # apply (sudo is added automatically on non-Darwin)
bin/update             # refresh pinned mitamae version + sha256 in bin/setup
tests/test_darwin.sh   # macOS smoke test (runs install.sh, then assertions)
tests/test_linux.sh    # Linux smoke test (same flow)
docker compose run --rm ubuntu   # run tests/test_linux.sh inside Ubuntu 22.04
```

There is no single-test runner — the test files are plain bash that call helpers from `tests/test_base.sh` (`test_symlink`, `test_command_exists`). To check one assertion, comment out the others in the relevant `test_*.sh`.

## mitamae / itamae DSL primer

This repo is driven by [**mitamae**](https://github.com/itamae-kitchen/mitamae), an mruby reimplementation of [itamae](https://github.com/itamae-kitchen/itamae) — a Chef-like configuration-management tool. The two share the same recipe DSL, and the [itamae wiki](https://github.com/itamae-kitchen/itamae/wiki) is the authoritative reference for resource semantics; mitamae just ships as a single static binary with no Ruby/gem dependencies, which is why `bin/mitamae` is a vendored executable.

Recipe files are Ruby-ish, declarative, and idempotent. Every top-level call is a **resource** describing desired state:

```ruby
package 'tmux'                       # install system package
directory "#{ENV['HOME']}/bin"       # ensure directory exists
execute 'curl ... | sh' do           # run a shell command
  not_if 'which starship'            # ...unless starship is already installed
end
remote_file "#{ENV['HOME']}/.gnupg/gpg-agent.conf" do
  source 'files/gpg-agent.conf'      # copy file from the cookbook
end
link link_from do                    # symlink (used by the dotfile helper)
  to target
  force true
end
```

Resource types used in this repo: `package`, `directory`, `execute`, `remote_file`, `link`, plus custom ones created via `define` (see below). Full list and attributes: <https://github.com/itamae-kitchen/itamae/wiki/Resources>.

Key cross-resource attributes — all resources accept these:
- `not_if '<shell>'` / `only_if '<shell>'` — guard clauses. The resource is skipped (or only runs) based on the command's exit status. This is how idempotency is achieved for `execute` blocks that aren't inherently idempotent (e.g. curl-pipe-sh installers).
- `user '<name>'` — run the action as another user.
- `notifies` / `subscribes` — trigger actions on other resources.

**`include_recipe '<name>'`** loads another recipe file relative to the current one — `recipes/default.rb` uses `include_recipe 'base'` and `include_recipe node[:platform]` to pull in `recipes/base/default.rb` and `recipes/darwin/default.rb` (or `ubuntu/default.rb`). Recipes inside subdirectories (like `recipes/darwin/brew.rb`) are included with their basename: `include_recipe 'brew'`.

**`define :name do ... end`** declares a custom, reusable resource — the Ruby-inside-Ruby equivalent of a function. `recipes/base/helpers.rb` defines `dotfile` and `github_binary` this way; once included via `include_recipe 'helpers'`, they can be called anywhere like a built-in resource. Parameters come in via `params[:name]` (the positional arg) and any keyword options passed in the `define` header.

**`node` attributes** are the shared state passed between recipes. `recipes/base/default.rb` seeds `node[:os]` and `node[:user]` with `node.reverse_merge!(...)`, and `node[:platform]` is auto-populated by mitamae (`darwin`, `ubuntu`, …). Read with `node[:key]`. External values can be injected via `--node-json`, but this repo doesn't use that path.

## Provisioning architecture

The flow:

1. `install.sh` → `bin/setup` downloads the pinned `mitamae` binary (checksum-verified) into `bin/`.
2. `install.sh` invokes `bin/mitamae local recipes/default.rb`.
3. `recipes/default.rb` always loads `base`, then dispatches to the platform recipe via `node[:platform]` (`darwin` or `ubuntu`).

Recipe layout:
- `recipes/base/default.rb` — cross-platform setup. Sets `node[:os]` / `node[:user]`, includes `helpers`, installs `peco` via `github_binary`.
- `recipes/base/helpers.rb` — defines two DSL primitives used throughout:
  - `dotfile '<relative path>'` — symlinks `$HOME/<path>` to `config/<path>` (or to a different source when called with `'a' => 'b'`). This is how every dotfile in `config/` reaches the user's home.
  - `github_binary <name>` — downloads, extracts, and installs a release asset to `~/bin/`.
- `recipes/darwin/` — macOS. `default.rb` declares the dotfile set + runs `brew`, `gpg-agent`, and curl-based installers (starship, rustup, sheldon). `brew.rb` installs Homebrew itself then runs `brew bundle` against `files/base.brew` (CLI tools) and `files/gui.brew` (casks).
- `recipes/ubuntu/` — Ubuntu. Similar structure but uses `package` resources plus curl installers; no Brewfile.

Both platform recipes maintain **separate `dotfile` lists**, so when adding a new config you typically edit both `recipes/darwin/default.rb` and `recipes/ubuntu/default.rb`. Platform-specific variants are handled by mapping (e.g. `dotfile '.tmux.conf.local' => '.tmux.conf.darwin'`).

## config/ layout

`config/` mirrors the structure of `$HOME`: top-level entries are the symlink *targets* (`.zshrc`, `.tmux.conf`, `.config/nvim/`, …). The `dotfile` helper never copies — it only symlinks — so editing a file under `config/` immediately affects the live dotfile on a provisioned machine.

Platform-specific dotfile variants use suffix convention: `.zshrc.darwin`, `.zshrc.Linux`, `.tmux.conf.darwin`, etc. The platform recipe picks the right one via the `dotfile 'a' => 'b'` mapping.

## Adding a package

- macOS CLI tool: append to `recipes/darwin/files/base.brew` (GUI apps go in `gui.brew`).
- Ubuntu package: add `package '<name>'` in `recipes/ubuntu/default.rb`, or a curl-based `execute` block guarded by `not_if "which <cmd>"` when the package isn't in apt.
- Binary from GitHub releases (cross-platform): use the `github_binary` helper in `recipes/base/default.rb`.

## Testing flow

`tests/test_base.sh` is sourced by both platform test scripts. It runs `./install.sh` itself as part of the test, so running a test script performs a full provisioning pass. CI (`.github/workflows/ci.yml`) runs both `test_linux.sh` on `ubuntu-latest` and `test_darwin.sh` on `macos-latest`. For local Linux testing without touching the host, use `docker compose run --rm ubuntu`, which builds `Dockerfile.test.linux` and runs the same script inside a clean Ubuntu 22.04 container.
