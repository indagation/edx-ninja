# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'oauth/request_proxy/rack_request'
OAUTH_10_SUPPORT = true

# Initialize the Rails application.
Rails.application.initialize!
