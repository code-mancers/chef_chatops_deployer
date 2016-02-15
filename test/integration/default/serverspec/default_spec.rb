require 'spec_helper'

describe 'Default recipe' do
  describe file("/home/vagrant/.netrc") do
    it { should contain 'machine github.com login fake_gh_oauth_token password' }
  end

  describe file("/home/vagrant/.ssh/config") do
    it { should contain "Host github.com\n    StrictHostKeyChecking no" }
  end

  describe service('supervisor') do
    it { should be_running }
    it { should be_enabled }
  end

  describe command("ruby -v") do
    its(:stdout) { should match /ruby 2.2/ }
  end

  describe file("/etc/hosts") do
    it { should contain "127.0.0.1	my.dockerhub" }
  end

  describe command("sysctl -n fs.aio-max-nr") do
    its(:stdout) { should eql "200000\n" }
  end

  describe command("docker -v") do
    its(:stdout) { should match /Docker version 1.9.0/ }
  end

  describe command("cd /home/vagrant/chatops_deployer && git show --name-only") do
    its(:stdout) { should match /9706fdc0368fe765696a89211366d44f30b0ed9d/ }
  end
end
