require 'spec_helper'

describe 'Default recipe' do
  let!(:ip) { `/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`.strip }
  describe "base recipe" do
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

    describe service('nginx') do
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
  end

  describe 'chatops_deployer app recipe' do
    describe command("cd /usr/lib/chatops_deployer && git show --name-only") do
      its(:stdout) { should match /9706fdc0368fe765696a89211366d44f30b0ed9d/ }
    end

    describe file("/usr/lib/chatops_deployer/exe/chatops_deployer.supervisor") do
      it { should contain "ENV['DEPLOYER_HOST'] = '#{ip}.xip.io'" }
      it { should contain "ENV['GITHUB_WEBHOOK_SECRET'] = 'fake_gh_webhook_secret'" }
      it { should contain "ENV['GITHUB_OAUTH_TOKEN'] = 'fake_gh_oauth_token'" }
      it { should contain "ENV['DEPLOYER_LOG_URL'] = 'http://#{ip}.xip.io:9001'" }
      it { should contain "require 'chatops_deployer/app.rb'" }
    end

    describe command('supervisorctl status') do
      its(:stdout) { should match /chatops_deployer\s*RUNNING/ }
    end

    describe 'frontail service' do
      describe command('supervisorctl status') do
        its(:stdout) { should match /frontail\s*RUNNING/ }
      end

      describe command('curl http://127.0.0.1:9001') do
        its(:stdout) { should match /<title>tail -F \/var\/log\/chatops_deployer.log<\/title>/ }
      end
    end
  end

  describe 'docker_auto_build app recipe' do
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

  describe 'hubot recipe' do
    describe file("/usr/lib/hubot/bin/hubot.supervisor") do
      it { should contain "export HUBOT_HIPCHAT_JID=fake_hipchat_jid" }
      it { should contain "export HUBOT_HIPCHAT_PASSWORD=fake_hipchat_password" }
      it { should contain "export OTHER_ENV=secret" }
      it { should contain "export HUBOT_HIPCHAT_JOIN_PUBLIC_ROOMS=false" }
      it { should contain "export PORT=8080" }
      it { should contain "export DEPLOYER_URL=http://127.0.0.1:8000" }
      it { should contain "export HUBOT_URL=http://127.0.0.1:8080" }
      it { should contain "exec node_modules/.bin/hubot --name \"fred\" -a hipchat" }
    end

    describe command('supervisorctl status') do
      its(:stdout) { should match /hubot\s*RUNNING/ }
    end
  end

  describe command('docker tag -f tianon/true:latest my.dockerhub:5000/new:tag && docker push my.dockerhub:5000/new:tag && docker pull my.dockerhub:5000/new:tag') do
    its(:stdout) { should match /tag: Pulling from new/ }
    its(:stdout) { should match /Image is up to date/ }
  end
  describe 'docker images clean up recipe' do
    describe file('/usr/sbin/docker-gc') do
      it { should exist }
      it { should be_executable }
    end
    describe file('/etc/docker-gc-exclude-containers') do
      it { should exist }
      its(:content) { should match /cache/ }
    end
    describe cron do
      it { should have_entry '0 * * * * /usr/sbin/docker-gc' }
    end
  end
end
