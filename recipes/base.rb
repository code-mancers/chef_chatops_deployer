include_recipe 'chef-vault'
include_recipe 'apt'
include_recipe 'build-essential'
home = Dir.respond_to?(:home) ? Dir.home : ENV['HOME']

ruby_block "read secrets" do
  block do
    node.run_state['secrets'] = chef_vault_item(node['chatops_deployer']['vault'], 'secrets')
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

# Create ~/.ssh/config with entry for github.com so that
# prompt for adding github.com to known_hosts is supressed.
template "#{home}/.ssh/config" do
  source 'ssh_config.erb'
  action :create
end

# Install supervisor to manage processes
include_recipe "supervisor"

# Install ruby 2.2
include_recipe 'ruby-ng'

# Install ruby headers for compiling native extensions
execute "Ruby dev headers" do
  command "apt-get -y install ruby2.2-dev"
end


# Add /etc/hosts entry for dockerhub
hostsfile_entry node['chatops_deployer']['private_docker_registry']['ip'] do
  hostname node['chatops_deployer']['private_docker_registry']['hostname']
  action :create
  only_if { node['chatops_deployer']['private_docker_registry'] }
end

execute "Increase async IO limit in OS" do
  command "sysctl -w fs.aio-max-nr=200000"
end

package "git"
include_recipe 'nodejs'
