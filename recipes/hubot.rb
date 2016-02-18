directory "#{node['chatops_deployer']['hubot']['path']}/bin" do
  recursive true
end

template "#{node['chatops_deployer']['hubot']['path']}/bin/hubot.supervisor" do
  source 'hubot_starter_script.erb'
  variables(lazy {
    {
      name: node['chatops_deployer']['hubot']['name'],
      adapter: node['chatops_deployer']['hubot']['adapter'],
      env: node.run_state['secrets']['hubot_env'].merge(node['chatops_deployer']['hubot']['env'])
    }
  })
  mode '700'
  action :create_if_missing
end

template "#{node['chatops_deployer']['hubot']['path']}/package.json" do
  source 'hubot_package_json.erb'
  action :create_if_missing
end

file "#{node['chatops_deployer']['hubot']['path']}/external-scripts.json" do
  content "['hubot-chatops', 'hubot-help']"
  action :create_if_missing
end

execute "Install hubot adapter" do
  command "cd #{node['chatops_deployer']['hubot']['path']} && npm install --save hubot-#{node['chatops_deployer']['hubot']['adapter']}"
end

execute "Run npm install in hubot" do
  command "cd #{node['chatops_deployer']['hubot']['path']} && npm install"
end

supervisor_service "hubot" do
  action [:enable, :start]
  command "#{node['chatops_deployer']['hubot']['path']}/bin/hubot.supervisor"
  directory node['chatops_deployer']['hubot']['path']
  autorestart true
  stdout_logfile "#{node['chatops_deployer']['hubot']['path']}/out.log"
  stdout_logfile_maxbytes "5MB"
  redirect_stderr true
end
