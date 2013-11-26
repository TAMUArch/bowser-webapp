
require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'

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
  slim :signin
end

get '/secure/bowser' do
  slim :bowser
end
