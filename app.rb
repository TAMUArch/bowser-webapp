require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'sinatra/contrib'
require 'yaml'

config_file 'config.yml'

configure do
# uncomment for use with vagrant
#  set :bind, '0.0.0.0'
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
    redirect '/login/again'
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
    redirect '/login/again'
  end
end

get '/secure/bowser' do
  slim :secure
end

post '/logout' do
  session.delete(:identity)
  redirect '/logged/out'
end

get '/logged/out' do
  slim :logged_out
end

get '/secure/machine' do
  erb :machine_stats
end

get '/secure/network' do
  erb :network_form
end
