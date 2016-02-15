home = Dir.respond_to?(:home) ? Dir.home : ENV['HOME']

git "#{home}/chatops_deployer" do
  repository "https://github.com/code-mancers/chatops_deployer.git"
  revision "9706fdc0368fe765696a89211366d44f30b0ed9d"
end
