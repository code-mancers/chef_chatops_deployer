module HubotHelpers
  def npm_dependencies(adapter, external_scripts)
    dependencies.merge(adapter_dependency(adapter)).merge(external_scripts)
  end

  def hubot_env(adapter, secrets, config = {})
    adapter_config(adapter, secrets).merge(config)
  end

  def dependencies
    {
      "hubot-google-images" => "^0.1.4",
      "hubot-help" => "^0.1.1",
      "hubot-rules" => "^0.1.0",
      "hubot-chatops" => ">= 0.0.1"
    }
  end

  def adapter_dependency(adapter)
    case adapter
    when "hipchat"
      {'hubot-hipchat' => '>= 2.12.0'}
    when "slack"
      {'hubot-slack' => '3.4.2'}
    else
      raise "Don't know how to setup chatops for hubot adapter type '#{adapter}'"
    end
  end

  def adapter_config(adapter, secrets)
    case adapter
    when "hipchat"
      {
        'HUBOT_HIPCHAT_JID' => secrets['hubot_hipchat_jid'],
        'HUBOT_HIPCHAT_PASSWORD' => secrets['hubot_hipchat_password']
      }
    when "slack"
      {'HUBOT_SLACK_TOKEN' => secrets['hubot_slack_token']}
    else
      raise "Don't know how to setup chatops for hubot adapter type '#{adapter}'"
    end
  end
end
