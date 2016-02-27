# Ruby version
default['ruby-ng']['ruby_version'] = '2.2'

# Assumes your private docker registry is referenced using my.dockerhub host
# and that it runs on localhost on port 5000
default['chatops_deployer']['private_docker_registry']['ip'] = '127.0.0.1'
default['chatops_deployer']['private_docker_registry']['hostname'] = 'my.dockerhub'
default['chatops_deployer']['private_docker_registry']['port'] = '5000'
default['chatops_deployer']['ipaddress'] = (node['cloud'] ? node['cloud']['public_ipv4'] : node['ipaddress'])
default['chatops_deployer']['vault'] = 'changeme'

# Directory where chatops_deployer app will be cloned
default['chatops_deployer']['app']['path'] = '/usr/lib/chatops_deployer'
# URL where frontail exposes the logs
default['chatops_deployer']['app']['log_url'] = "http://#{node['chatops_deployer']['ipaddress']}.xip.io:9001"
# Hostname of chatops deployer
default['chatops_deployer']['deployer_host'] = "#{node['chatops_deployer']['ipaddress']}.xip.io"

# Directory where docker_auto_build app will be cloned
default['chatops_deployer']['docker_auto_build']['path'] = '/usr/lib/docker_auto_build'
# Port on which docker_auto_build app listens
default['chatops_deployer']['docker_auto_build']['port'] = '8001'
# Directory where docker_gc will be cloned
default['chatops_deployer']['docker_clean_up']['path'] = '/usr/lib/docker_clean_up'

default['chatops_deployer']['hubot']['path'] = '/usr/lib/hubot'
default['chatops_deployer']['hubot']['adapter'] = 'hipchat' # or 'slack'
default['chatops_deployer']['hubot']['name'] = 'fred' # Name of your hubot bot
default['chatops_deployer']['hubot']['env'] = {
  # If using slack, set this as a node attribute or as a secret:
  #"HUBOT_SLACK_TOKEN" => "",  # Should be set using chef-vault as chatops_deployer => secrets => hubot_env => HUBOT_SLACK_TOKEN => value

  # If using hipchat, set this as node attributes or as secrets using chef-vault:
  #"HUBOT_HIPCHAT_JID" => "",  # Should be set using chef-vault as chatops_deployer => secrets => hubot_env => HUBOT_HIPCHAT_JID => value
  #"HUBOT_HIPCHAT_PASSWORD" => "",  # Should be set using chef-vault as chatops_deployer => secrets => hubot_env => HUBOT_HIPCHAT_PASSWORD => value
  "HUBOT_HIPCHAT_JOIN_PUBLIC_ROOMS" => "false",

  "PORT" => "8080",
  "DEPLOYER_URL" => "http://127.0.0.1:8000",
  "HUBOT_URL" => "http://127.0.0.1:8080"
}

default['chatops_deployer']['private_docker_registry']['path'] = '/usr/lib/docker-registry'
