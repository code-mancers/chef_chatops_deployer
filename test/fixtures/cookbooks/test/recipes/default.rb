include_recipe 'chef-vault'

chef_vault_secret 'secrets' do
  data_bag 'chatops_deployer'
  raw_data(
    'github_bot_oauth_token' => 'fake_gh_oauth_token'
  )
  admins 'admin'
  clients 'admin'
end

include_recipe 'chatops_deployer'
