# chatops_deployer

This cookbooks automates the set up of the following apps on an Ubuntu box:

1. chatops_deployer
2. docker_auto_build
3. hubot
4. private docker registry
5. frontail

## Attributes and secrets

This cookbook needs the following node attributes:

```
node['chatops_deployer']['vault'] = '<chef-vault name in which secrets are stored>'
node['chatops_deployer']['hubot']['adapter'] = 'hipchat' # Or "slack" for example
node['chatops_deployer']['hubot']['name'] = '<hubot's name>'
```

Also, set the following secrets using chef-vault under the vault name specified above:

```
{
  secrets: {
    github_bot_oauth_token: 'fake_gh_oauth_token', # Oauth token of github bot user
    github_webhook_secret: 'fake_gh_webhook_secret', # Github webhook secret

    # All environment variables required by hubot
    hubot_env: {
      HUBOT_HIPCHAT_JID: 'fake_hipchat_jid',
      HUBOT_HIPCHAT_PASSWORD: 'fake_hipchat_password',
      OTHER_ENV: 'secret'
    },

    # These will be used to authenticate with the private docker
    # registry using `docker login`, for pushing docker images.
    private_docker_registry_username: => 'fake_username',
    private_docker_registry_password: => 'fake_password'
  }
}
```

To see a list of all other attributes which can be overridden and their default
values, please see the file `attributes/default.rb`

Please see [this wiki](TODO) for step by step instructions to use this
cookbook to bootstrap a server.

## Testing

On a box with vagrant and chefdk,

```
$ kitchen converge # Runs the chef recipe
$ kitchen verify # Runs tests to verify the state after converging
```
