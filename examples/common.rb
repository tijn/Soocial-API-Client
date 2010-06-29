# add the soocial client libs to the load path
APP_ROOT = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{APP_ROOT}/../lib") { |libdir| $:.unshift libdir }

require 'rubygems'
gem 'oauth', '>= 0.3.6'
require 'oauth'
