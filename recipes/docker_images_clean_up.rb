package 'devscripts'
package 'debhelper'

git node['chatops_deployer']['docker_clean_up']['path'] do
  repository 'https://github.com/spotify/docker-gc.git'
  revision '5ebb00f5f163126c29661cf4ebb674505e77ff8e'
end

execute 'Build and install the Docker-gc debian package' do
  command "cd #{node['chatops_deployer']['docker_clean_up']['path']} && debuild --no-lintian -us -uc -b && dpkg -i ../docker-gc_0.1.0_all.deb"
end

execute "Exclude cache container from being G'C'd" do
  command "echo cache > /etc/docker-gc-exclude-containers"
end

template "/etc/cron.hourly/docker-gc" do
  source "docker_gc_script.erb"
  action :create_if_missing
end
