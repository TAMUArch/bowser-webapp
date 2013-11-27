require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'sinatra/contrib'
require 'yaml'

config_file 'secure.yaml'

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

=begin
before '/secure/*' do
  unless session[:username, :password] == ["charlie", "texas"]
    session[:previous_url] = request.path
    @error = 'Yo dude, you need to be logged in to get to ' + request.path
    halt slim(:login)
  end
end
=end

get '/' do
  slim :login
end

post '/login/attempt' do
  session[:username, :password] = params['username', 'password']
  go_back = session[:previous_url] || '/'
  redirect to go_back
end

get '/secure/bowser' do
  slim :secure
end
