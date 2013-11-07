require 'sinatra'

get '/' do
  "Welcome to your Bowser Web App! You can do shit here!"
end

get '/about' do
  "about stuff"
end

get '/form' do
  erb :form
end

post '/form' do
  "Your new hostname is: #{params[:hostname]}"
  cmd = `sudo hostname #{params[:hostname]}`
end
