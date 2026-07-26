package 'pipx'

execute 'pipx install uv' do
    not_if 'test -x "$HOME/.local/bin/uv"'
end
