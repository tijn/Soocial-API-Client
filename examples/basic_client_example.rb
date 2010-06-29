require File.expand_path('common', File.dirname(__FILE__))
require 'soocial/basic_client'

CONSUMER_KEY = CONSUMER_KEY_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL
CONSUMER_SECRET = CONSUMER_SECRET_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL

# so foo is an OAuth client...
foo = Soocial::CommandLineApp.new(:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET)

puts foo.access_token.inspect # just because we can!

### it does not have an access token, so get one:
foo.authorize!

puts foo.access_token.inspect # just because we can!

# and then foo can access the user's data...
puts foo.get('/contacts.json').inspect

# or...

puts foo.get('/contacts.xml').inspect

foo.put('/contacts/11/emails/')
