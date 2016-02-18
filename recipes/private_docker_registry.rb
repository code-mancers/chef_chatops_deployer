dir = node['chatops_deployer']['private_docker_registry']['path']
hostname = node['chatops_deployer']['private_docker_registry']['hostname']
port = node['chatops_deployer']['private_docker_registry']['port']

[
  "#{dir}/data",
  "#{dir}/auth",
  "#{dir}/certs",
].each do |dir|
  directory dir do
    recursive true
  end
end

execute "Set username and password of docker registry login" do
  command "cd #{dir} && docker run --entrypoint htpasswd registry:2 -Bbn #{node.run_state['secrets']['private_docker_registry_username']} #{node.run_state['secrets']['private_docker_registry_password']} > auth/htpasswd" do
  not_if { ::File.exists?("#{dir}/auth/htpasswd") }
end

directory "/etc/docker/certs.d/#{hostname}:#{port}" do
  recursive true
end

openssl_x509 "#{dir}/certs/domain.crt" do
  common_name hostname
  org 'Foo Bar'
  org_unit 'Lab'
  country 'US'
end

file "/etc/docker/certs.d/#{hostname}:#{port}/ca.crt" do
  content IO.read("#{dir}/certs/domain.crt")
  action :create
end

#file "/etc/docker/certs.d/#{hostname}:#{port}/ca.crt" do
  #content node.run_state['secrets']['private_docker_registry_crt']
  #action :create_if_missing
#end

#file "#{dir}/certs/domain.crt" do
  #content node.run_state['secrets']['private_docker_registry_crt']
  #action :create_if_missing
#end

#file "#{dir}/certs/domain.key" do
  #content node.run_state['secrets']['private_docker_registry_key']
  #action :create_if_missing
#end

service 'docker' do
  action :restart
end

template "#{dir}/docker-compose.yml" do
  source "private_docker_registry_docker_compose_yml.erb"
  action :create_if_missing
end

execute "Start docker registry" do
  command "cd #{dir} && docker-compose up -d"
end

docker_registry 'Login to private registry' do
   serveraddress "https://#{hostname}:#{port}/"
   username node.run_state['secrets']['private_docker_registry_username']
   password node.run_state['secrets']['private_docker_registry_password']
   email 'test@example.com'
end
