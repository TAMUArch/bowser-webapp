require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'sinatra/contrib'
require 'yaml'

config_file 'secure.yaml'

helpers do

#  def username
#    session[:identity] ? session[:identity] : 'Login!'
#  end

  def system
    ohai = Ohai::System.new
    ohai.all_plugins
    ohai
  end
end

#before '/secure/*' do
#  unless session{:username => :password}
#    session[:previous_url] = request.path
#    @error = 'Yo dude! You need to be logged in to get to' + request.path
#    halt slim(:signin)
#  end
#end

get '/' do
  slim :login
end

get '/secure/bowser' do
  slim :secure
end


#YAML FILE LOOKS LIKE THIS:
#
#hash:
#  charlie: texas
#  root: admin
