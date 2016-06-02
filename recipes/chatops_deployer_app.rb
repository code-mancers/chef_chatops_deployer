package 'nginx'
service 'nginx' do
  action [ :enable, :start ]
end

package 'curl'
bash 'Install docker-compose' do
  code <<-EOH
    curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    EOH
  not_if { ::File.exists?('/usr/local/bin/docker-compose') }
end

# Clone chatops_deployer
git node['chatops_deployer']['app']['path'] do
  repository "https://github.com/code-mancers/chatops_deployer.git"
  revision "872e7d3a6f4c110e874a32ded0a281427ebacb1f"
end

template "#{node['chatops_deployer']['app']['path']}/exe/chatops_deployer.supervisor" do
  source 'chatops_deployer_starter_script.erb'
  variables(lazy {
    {
      github_bot_oauth_token: node.run_state['secrets']['github_bot_oauth_token'],
      github_webhook_secret: node.run_state['secrets']['github_webhook_secret']
    }
  })
  action :create
end

gem_package "bundler"

execute "Run bundle install in chatops_deployer" do
  command "cd #{node['chatops_deployer']['app']['path']} && bundle install"
end

supervisor_service "chatops_deployer" do
  action [:enable, :start]
  command "/usr/bin/ruby #{node['chatops_deployer']['app']['path']}/exe/chatops_deployer.supervisor"
  directory node['chatops_deployer']['app']['path']
  autorestart true
  stdout_logfile "#{node['chatops_deployer']['app']['path']}/out.log"
  stdout_logfile_maxbytes "5MB"
  redirect_stderr true
end

file "/var/log/chatops_deployer.log" do
  content ""
end

execute "Install frontail" do
  command "npm install -g frontail"
end

supervisor_service "frontail" do
  action [:enable, :start]
  command "frontail /var/log/chatops_deployer.log"
  autorestart true
end
