
require 'rubygems'
require 'sinatra'
require 'slim'

get '/' do
  slim :signin
end
