node.reverse_merge!(
  os: run_command('uname').stdout.strip.downcase,
  user: ENV['SUDO_USER'] || ENV['USER'],
)

include_recipe 'helpers'

directory "#{ENV['HOME']}/bin" do
  owner node[:user]
end

github_binary 'peco' do
  repository 'peco/peco'
  version 'v0.5.10'
  ext = (node[:platform] == 'darwin' ? 'zip' : 'tar.gz')
  archive "peco_#{node[:os]}_amd64.#{ext}"
  binary_path "peco_#{node[:os]}_amd64/peco"
end
