# Clone chatops_deployer
git node['chatops_deployer']['docker_auto_build']['path'] do
  repository "https://github.com/code-mancers/docker_auto_build.git"
  revision "cf7cc061955e4e5a59353ffd84c197abb8e2c554"
end

template "#{node['chatops_deployer']['docker_auto_build']['path']}/exe/docker_auto_build.supervisor" do
  source 'docker_auto_build_starter_script.erb'
  variables(lazy {
    {
      github_bot_oauth_token: node.run_state['secrets']['github_bot_oauth_token'],
      github_webhook_secret: node.run_state['secrets']['github_webhook_secret']
    }
  })
  action :create
end

execute "Run bundle install in docker_auto_build" do
  command "cd #{node['chatops_deployer']['docker_auto_build']['path']} && bundle install"
end

supervisor_service "docker_auto_build" do
  action [:enable, :start]
  command "/usr/bin/ruby #{node['chatops_deployer']['docker_auto_build']['path']}/exe/docker_auto_build.supervisor"
  directory node['chatops_deployer']['docker_auto_build']['path']
  autorestart true
  stdout_logfile "#{node['chatops_deployer']['docker_auto_build']['path']}/out.log"
  stdout_logfile_maxbytes "5MB"
  redirect_stderr true
end
