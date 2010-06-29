require File.expand_path('common', File.dirname(__FILE__))
require 'sinatra'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end


# Soocial::SITE = 'http://api.soocial.com'
Soocial::SITE = 'http://localhost:3000'

CONSUMER_KEY = CONSUMER_KEY_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL
CONSUMER_SECRET = CONSUMER_SECRET_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL
enable :sessions

before do
  session[:oauth] ||= {}
end


### oauth methods ###
def consumer
  OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { :site => Soocial::SITE })
end

def authorize(token, secret, options = {})
  rt = OAuth::RequestToken.new(consumer, token, secret)
  session[:oauth][:access_token] = rt.get_access_token(options)
end

def access_token
  session[:oauth][:access_token]
end
### end oauth methods ###



get "/" do
  if access_token.nil?
    erb "Hi, I need access to your soocial account! <a href=\"/oauth/request\">authorize</a>"
  else
    response = access_token.get('/contacts.json')
    x = JSON.load(response.body).map do |contact|
      "<li><a href=\"/contacts/#{h contact['id']}\">#{h contact['formatted_name']}</a></li>"
    end
    erb "<ol>#{x.join}</ol>"
  end
end


get "/contacts/:id" do
  if access_token.nil?
    erb "Hi, I need access to your soocial account! <a href=\"/oauth/request\">authorize</a>"
  else
    response = access_token.get("/contacts/#{params[:id]}.json")
    erb "<h2>#{escape_html(response.inspect)}</h2><p>#{escape_html(response.body)}</p>"
  end
end


get '/oauth/request' do
  session[:oauth][:request_token] = consumer.get_request_token
  redirect session[:oauth][:request_token].authorize_url
end


get '/oauth/callback' do
  # if we would not have a session, we would not know which token can be exchanged for an access token, that's why params[:oauth_token] is also sent but, like I said, in this example we don't need it.
  authorize(session[:oauth][:request_token].token, session[:oauth][:request_token].secret, :oauth_verifier => params[:oauth_verifier])
  # safely_store_the_access_token(access_token.token, access_token.secret)
  # ... in some way that you can find it via your user model,
  # ... and preferably in an encrypted format so that no other app (trojan horse) can steal it.
  #
  # okay, logged in... now redirect to / to see your contacts again
  redirect "/"
end


get "/logout" do
  session[:oauth] = {}
  redirect "/"
end


get '/hi' do
  "Hello World!"
end


# superduper brand new html5 layout
template :layout do
  <<-end_layout
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset=utf-8 />
  <title>Soocial example with Sinatra</title>
  <style type="text/css">
    body { font-family:"Lucida Grande","Bitstream Vera Sans",sans-serif; font-size: 9pt; background-color: #95ba0a; }
    article { display: block; width: 800px; margin: 2em auto; padding: 4em; background-color: white; }
  </style>
</head>
<body>
<article>
  <a href="/logout" style="float: right">logout</a>
  <h1>Soocial example with Sinatra</h1>
  <%= yield %>
</article>
</body>
</html>
end_layout
end
