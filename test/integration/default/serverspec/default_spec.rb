require 'spec_helper'

describe 'Default recipe' do
  describe file("/home/vagrant/.netrc") do
    it { should contain 'machine github.com login fake_gh_oauth_token password' }
  end

  describe command("docker -v") do
    its(:stdout) { should match /Docker version 1.9.0/ }
  end
end
