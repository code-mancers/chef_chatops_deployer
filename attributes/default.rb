# Ruby version
default['ruby-ng']['ruby_version'] = '2.2'

# Assumes your private docker registry is referenced using my.dockerhub host
# and that it runs on localhost on port 5000
default['chatops_deployer']['private_docker_registry']['ip'] = '127.0.0.1'
default['chatops_deployer']['private_docker_registry']['hostname'] = 'my.dockerhub'
default['chatops_deployer']['private_docker_registry']['port'] = '5000'

# Directory where chatops_deployer app will be cloned
default['chatops_deployer']['app']['path'] = '/usr/lib/chatops_deployer'
# URL where frontail exposes the logs
default['chatops_deployer']['app']['log_url'] = 'ip.xip.io:9001'
# Hostname of chatops deployer
default['chatops_deployer']['deployer_host'] = 'ip.xip.io'

# Directory where docker_auto_build app will be cloned
default['chatops_deployer']['docker_auto_build']['path'] = '/usr/lib/docker_auto_build'
# Port on which docker_auto_build app listens
default['chatops_deployer']['docker_auto_build']['port'] = '8001'

default['chatops_deployer']['hubot']['path'] = '/usr/lib/hubot'
default['chatops_deployer']['hubot']['adapter'] = 'hipchat' # or 'slack'
default['chatops_deployer']['hubot']['name'] = 'fred' # Name of your hubot bot
default['chatops_deployer']['hubot']['external_scripts'] = {
  "hubot-chatops" => ">= 0.0.1"
}
default['chatops_deployer']['hubot']['config'] = {
  "PORT" => "8080"
  "HUBOT_HIPCHAT_JOIN_PUBLIC_ROOMS" => "false",
  "DEPLOYER_URL" => "http://127.0.0.1:8000",
  "HUBOT_URL" => "http://127.0.0.1:8080"
}
