home = Dir.respond_to?(:home) ? Dir.home : ENV['HOME']

# Clone chatops_deployer
git node['chatops_deployer']['app']['path'] do
  repository "https://github.com/code-mancers/chatops_deployer.git"
  revision "9706fdc0368fe765696a89211366d44f30b0ed9d"
end

# Create ~/.ssh/config with entry for github.com so that
# prompt for adding github.com to known_hosts is supressed.
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
