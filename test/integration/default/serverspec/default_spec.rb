require 'spec_helper'

describe 'Default recipe' do
  describe file("/home/vagrant/.netrc") do
    it { should contain 'machine github.com login fake_gh_oauth_token password' }
  end

  describe file("/home/vagrant/.ssh/config") do
    it { should contain "Host github.com\n    StrictHostKeyChecking no" }
  end

  describe command("docker -v") do
    its(:stdout) { should match /Docker version 1.9.0/ }
  end
end
