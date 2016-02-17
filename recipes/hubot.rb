include HubotHelpers
# Hubot attributes
node.set['hubot']['name'] = node['chatops_deployer']['hubot']['name']
node.set['hubot']['install_dir'] = node['chatops_deployer']['hubot']['path']
node.set['hubot']['daemon'] = 'supervisor'
node.set['hubot']['dependencies'] = npm_dependencies(node['chatops_deployer']['hubot']['adapter'], node['chatops_deployer']['hubot']['external_scripts'])
node.set['hubot']['external_scripts'] = node['chatops_deployer']['hubot']['external_scripts'].keys

ruby_block "Set hubot environment vars" do
  node.set['hubot']['config'] = hubot_env(node['chatops_deployer']['hubot']['adapter'], node.run_state['secrets'], node['chatops_deployer']['hubot']['config'])
end

# OS packages required by assorted Hubot scripts
%w{ libexpat1 libexpat1-dev libicu-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "hubot"
