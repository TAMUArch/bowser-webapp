require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'sinatra/contrib'
require 'yaml'

config_file 'config.yml'

configure do
# uncomment for use with vagrant
# set :bind, '0.0.0.0'
  enable :sessions
end

helpers do
  def system
    ohai = Ohai::System.new
    ohai.all_plugins
    ohai
  end
end

before '/secure/*' do
  unless session[:identity] == 'admin'
    session[:previous_url] = request.path
    halt slim(:login)
    redirect '/login/again'
#    @error = 'You need to be logged in to access ' + request.path
  end
end

get '/' do
  slim :login
end

get '/login/again' do
  slim :again
end

post '/login/attempt' do
  if params['password'] == settings.credentials['password'] && params['username'] == settings.credentials['username']
    session[:identity] = 'admin'
    redirect '/secure/bowser'
  else
    redirect '/'
  end
end

get '/secure/bowser' do
  slim :secure
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged Out</div>"
end
