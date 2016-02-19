include_recipe 'chef-vault'

chef_vault_secret 'secrets' do
  data_bag 'myvault'
  raw_data(
    'github_bot_oauth_token' => 'fake_gh_oauth_token',
    'github_webhook_secret' => 'fake_gh_webhook_secret',
    'hubot_env' => {
      'HUBOT_HIPCHAT_JID' => 'fake_hipchat_jid',
      'HUBOT_HIPCHAT_PASSWORD' => 'fake_hipchat_password',
      'OTHER_ENV' => 'secret',
    },
    'private_docker_registry_username' => 'fake_username',
    'private_docker_registry_password' => 'fake_password'
  )
  admins 'admin'
  clients 'admin'
end

node.set['chatops_deployer']['vault'] = 'myvault'

include_recipe 'chatops_deployer'
