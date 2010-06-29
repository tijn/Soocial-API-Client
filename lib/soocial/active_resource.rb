# bad!
# gem 'oauth', '>= 0.3.6'
# gem 'oauth-active-resource'
require 'oauth'
require 'active_resource'
require 'oauth_active_resource'
require 'soocial/common'

module Soocial
  def self.register(options = {})
    raise 'need consumer_key' if options[:consumer_key].nil?
    raise 'need access_token' if options[:access_token].nil?
    options[:site] = options[:site] || SITE
    OAuthActiveResource.register(self.ancestors.first, self.ancestors.first.const_get('Models'), options)
  end
end


require 'soocial/models/base'
require 'soocial/models/contact'
require 'soocial/models/user'


# Soocial.register(:consumer_key => YOUR_APPLICATION_CONSUMER_TOKEN, :consumer_secret => YOUR_APPLICATION_CONSUMER_SECRET, :access_token => )

