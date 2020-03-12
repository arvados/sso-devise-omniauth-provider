# Load the rails application
require File.expand_path('../application', __FILE__)

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.4')
  raise "The SSO server must be run on Ruby version 2.3, version 2.4+ is not supported"
end

# Initialize the rails application
CfiOauthProvider::Application.initialize!
