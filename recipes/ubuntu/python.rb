package 'pipx'

execute 'pipx install uv' do
    not_if 'which uv'
end
