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

  describe command('docker-compose -v') do
    its(:stdout) { should match /docker-compose version 1.5.2/ }
  end

  describe command("cd /usr/lib/chatops_deployer && git show --name-only") do
    its(:stdout) { should match /9706fdc0368fe765696a89211366d44f30b0ed9d/ }
  end

  describe file("/usr/lib/chatops_deployer/exe/chatops_deployer.supervisor") do
    it { should contain "ENV['DEPLOYER_HOST'] = 'ip.xip.io'" }
    it { should contain "ENV['GITHUB_WEBHOOK_SECRET'] = 'fake_gh_webhook_secret'" }
    it { should contain "ENV['GITHUB_OAUTH_TOKEN'] = 'fake_gh_oauth_token'" }
    it { should contain "ENV['DEPLOYER_LOG_URL'] = 'ip.xip.io:9001'" }
    it { should contain "require 'chatops_deployer/app.rb'" }
  end

  describe command('supervisorctl status') do
    its(:stdout) { should match /chatops_deployer\s*RUNNING/ }
  end

  describe command("cd /usr/lib/docker_auto_build && git show --name-only") do
    its(:stdout) { should match /cf7cc061955e4e5a59353ffd84c197abb8e2c554/ }
  end

  describe file("/usr/lib/docker_auto_build/exe/docker_auto_build.supervisor") do
    it { should contain "ENV['PORT'] = '8001'" }
    it { should contain "ENV['DOCKER_REGISTRY_HOST'] = 'my.dockerhub:5000'" }
    it { should contain "ENV['GITHUB_WEBHOOK_SECRET'] = 'fake_gh_webhook_secret'" }
    it { should contain "ENV['GITHUB_OAUTH_TOKEN'] = 'fake_gh_oauth_token'" }
    it { should contain "require 'docker_auto_build/app.rb'" }
  end

  describe command('supervisorctl status') do
    its(:stdout) { should match /docker_auto_build\s*RUNNING/ }
  end
end
