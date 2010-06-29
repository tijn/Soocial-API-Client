require 'rubygems'
require 'oauth'
require 'json'
require 'soocial/common'

module Soocial


  class OauthConsumerApp
    def initialize(options = {})
      @consumer_key = options[:consumer_key]
      @consumer_secret = options[:consumer_secret]
      @token = options[:token]
      @secret = options[:secret]
    end

    def authorize(token, secret, options = {})
      request_token = OAuth::RequestToken.new(consumer, token, secret)
      @access_token = request_token.get_access_token(options)
      @token = @access_token.token
      @secret = @access_token.secret
      @access_token
    end

    def request_token(options = {})
      rt = consumer.get_request_token(options)
      yield rt if block_given?
      rt
    end

    def authentication_request_token(options = {})
      consumer.options[:authorize_path] = '/oauth/authorize'
      request_token(options)
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, { :site => SITE })
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
    end
  end


  # This class is meant to base your own app on
  #   class AwesomeApp < Soocial::BasicApp
  #     ...
  class BasicApp < OauthConsumerApp
    def get(url)
      response = access_token.get(url)
      if url =~ /.json$/
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def post(url, body = '', headers = {})
      response = access_token.post(url, body, headers)
      if url =~ /.json$/
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def delete(url)
      response = access_token.delete(url)
      if url =~ /.json$/
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def put(url)
      response = access_token.put(url)
      if url =~ /.json$/
        JSON.parse(response.body)
      else
        response.body
      end
    end
  end


  class CommandLineApp < BasicApp
    def open_url(url)
      if RUBY_PLATFORM =~ /darwin/
        `open #{url}`
      elsif RUBY_PLATFORM =~ /linux/ && `which xdg-open` != ""
        `xdg-open #{url}`
      elsif RUBY_PLATFORM =~ /mswin|mingw|bccwin|wince|em/
        `start #{url}`
      else
        puts "Please open #{@authorize_url + request_token.token} in a web browser.  "
      end
    end

    # NB. The callback url has to be a url that your browser can access.
    #     This means it may be an 'app://'-style-url for phones like Android or iPhone.
    def authorize!(oauth_callback = 'http://localhost:3001/', options = {})
      request_token(:oauth_callback => oauth_callback) do |request_token|
        open_url(request_token.authorize_url)
        puts "please enter the oauth verifier code" # you don't normally do this manually
        pin = STDIN.readline.chomp
        # if the application is authorized by the user, foo can acquire an access token. Let's try:
        authorize(request_token.token, request_token.secret, :oauth_verifier => pin)
      end
    end
    ### end of OAuth process
  end

end
