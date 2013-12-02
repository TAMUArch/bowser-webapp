require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'sinatra/contrib'
require 'yaml'

config_file 'secure.yml'

configure do
# uncomment for use with vagrant
# set :bind, '0.0.0.0'
  enable :sessions
end

helpers do
#  def username
#    session[:identity] ? session[:identity] : 'Hello User'
#  end

  def system
    ohai = Ohai::System.new
    ohai.all_plugins
    ohai
  end
end

=begin
before '/secure/*' do
  unless session[:identity] == 'charlie'
    session[:previous_url] = request.path
    @error = 'You need to be logged in to get to ' + request.path
    halt slim(:login)
  end
end
=end

get '/' do
  slim :login
end

#post '/login/attempt' do
#  if params['username']=='charlie'&&params['password']=='texas'
#    session[:identity] = 'charlie'
#    redirect to '/secure/bowser'
#  else
#    "Username or password incorrect"
#  end
#session[:identity] = params['username']
#  go_back = session[:previous_url] || '/'
#  redirect to go_back
#end

#get '/logout' do
#  session.delete(:identity)
#  erb "<div class='alert alert-message'>Logged out</div>"
#end

get '/secure/bowser' do
  slim :secure
end
