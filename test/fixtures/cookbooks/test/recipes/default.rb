include_recipe 'chef-vault'

chef_vault_secret 'secrets' do
  data_bag 'chatops_deployer'
  raw_data(
    'secret_key' => 'secret_value'
  )
  admins 'admin'
  clients 'admin'
end

ruby_block "read secrets" do
  block do
    node.run_state['secrets'] = chef_vault_item('chatops_deployer', 'secrets')
  end
end

file '/tmp/secret_key' do
  content lazy { node.run_state['secrets']['secret_key'] }
end
