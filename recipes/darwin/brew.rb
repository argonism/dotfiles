execute "Install homebrew" do
  command <<-EOH
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  EOH
  not_if "which brew"
end

execute "Install homebrew packages" do
  command "brew bundle --file=#{File.expand_path('../files/Brewfile', __FILE__)}"
  only_if "which brew"
end
