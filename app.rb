
require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'

helpers do

  def username
    session[:identity] ? session[:identity] : 'Login!'
  end

  def system
    ohai = Ohai::System.new
    ohai.all_plugins
    ohai
  end
end

get '/' do
  slim :signin
end
