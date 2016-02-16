default['ruby-ng']['ruby_version'] = '2.2'

# Assumes your private docker registry is referenced using my.dockerhub host
# and that it runs on localhost
default['chatops_deployer']['private_docker_registry']['ip'] = '127.0.0.1'
default['chatops_deployer']['private_docker_registry']['hostname'] = 'my.dockerhub'

# Directory where chatops_deployer app will be cloned
default['chatops_deployer']['app']['path'] = '/usr/lib/chatops_deployer'
default['chatops_deployer']['app']['log_url'] = 'ip.xip.io:9001'
default['chatops_deployer']['deployer_host'] = 'ip.xip.io'
