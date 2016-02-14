include_recipe 'chef-vault'
vault = 'chatops_deployer'

begin
  secrets = chef_vault_item(vault, 'secrets')
rescue ChefVault::Exceptions::KeysNotFound => e
  log e.message
  log 'Cannot read secrets. Check if data bag exists.'
end

# Install and start docker v1.9.0
docker_service 'default' do
  install_method 'binary'
  version '1.9.0'
end

# Create ~/.netrc with github oauth token of bot user
# This is for cloning repos without needing to use passwords
template "~/.netrc" do
  source 'netrc.erb'
  variables(
    :github_bot_oauth_token => secrets['github_bot_oauth_token']
  )
  action :create
end
