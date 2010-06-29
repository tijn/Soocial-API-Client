# add the soocial client libs to the load path
APP_ROOT = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{APP_ROOT}/../lib") { |libdir| $:.unshift libdir }

require 'rubygems'
gem 'oauth', '>= 0.3.6'
require 'oauth'

require 'soocial/basic_client'
CONSUMER_KEY_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL = 'G9mX3kZPMOL1AvPUJX8vnQ'
CONSUMER_SECRET_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL = 'STJqFWIQwclxWcRJucdvf3hX61YXQLt25fgQrlBHI'
Soocial::SITE = 'http://localhost:3000'
