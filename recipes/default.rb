include_recipe "chatops_deployer::base"
include_recipe "chatops_deployer::chatops_deployer_app"
include_recipe "chatops_deployer::docker_auto_build_app"
include_recipe "chatops_deployer::hubot"
include_recipe "chatops_deployer::private_docker_registry"
include_recipe "chatops_deployer::docker-gc"
