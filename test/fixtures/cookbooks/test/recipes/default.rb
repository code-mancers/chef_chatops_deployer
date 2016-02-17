include_recipe 'chef-vault'

chef_vault_secret 'secrets' do
  data_bag 'chatops_deployer'
  raw_data(
    'github_bot_oauth_token' => 'fake_gh_oauth_token',
    'github_webhook_secret' => 'fake_gh_webhook_secret',
    'hubot_hipchat_jid' => 'fake_hipchat_jid',
    'hubot_hipchat_password' => 'fake_hipchat_password',
    'hubot_slack_token' => 'fake_slack_token'
  )
  admins 'admin'
  clients 'admin'
end

include_recipe 'chatops_deployer'
