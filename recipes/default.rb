include_recipe 'chef-vault'
home = Dir.respond_to?(:home) ? Dir.home : ENV['HOME']

ruby_block "read secrets" do
  block do
    node.run_state['secrets'] = chef_vault_item('chatops_deployer', 'secrets')
  end
end

# Install and start docker v1.9.0
docker_service 'default' do
  install_method 'binary'
  version '1.9.0'
end

# Create ~/.netrc with github oauth token of bot user
# This is for cloning repos without needing to use passwords
template "#{home}/.netrc" do
  source 'netrc.erb'
  variables(lazy {
    {
      github_bot_oauth_token: node.run_state['secrets']['github_bot_oauth_token']
    }
  })
  action :create
end
