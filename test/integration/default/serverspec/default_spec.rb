require 'spec_helper'

describe 'chef_vault_secret resource' do
  describe file('/tmp/secret_key') do
    it { should contain 'secret_value' }
  end
end
