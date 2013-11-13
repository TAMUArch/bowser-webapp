require 'rubygems'
require 'sinatra'
require 'ohai'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

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

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do 
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end


#get '/secure/place' do
#  erb "Welcome to your basic machine settings<%=session[:identity]%> has access to!"
#end

#My Temporary Code

get '/network/form' do
  erb :network_form
end

post '/network/form' do
  puts "Your new hostname is #{params[:hostname]}"
  puts "Your new IP address is #{params[:ip]}"
  hostname = `sudo su -c 'echo #{params[:hostname]} > /etc/hostname && hostname #{params[:hostname]}'`
  ip = `sudo ip addr add #{params[:ip]}/#{params[:subnet]} dev eth0`
  redirect "/network/form"
end

get '/machine/stats' do
  erb :machine_stats
end
