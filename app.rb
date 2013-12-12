require 'rubygems'
require 'sinatra'
require 'slim'
require 'ohai'
require 'yaml'
require 'sinatra/contrib'
require 'network_interface'

config_file 'config.yml'

configure do
# uncomment for use with vagrant
#  set :bind, '0.0.0.0'
  enable :sessions
end

helpers do
  def gateway
    gate = `ip route show | grep default`
    way = gate.split(' ')
    @gateway = way[2]
  end
  def cidr
    foo = `ip route show`
    bar = foo.split('/')
    foobar = bar[1].split(' ')
    @cidr = foobar[0]
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

post '/secure/bowser' do

  puts "Your hostname is #{params[:hostname]}"
  puts "Your ip address is #{params[:ip]}"
  puts "Your interface is #{params[:interface]}"
  puts "Your netmask is #{params[:netmask]}"
  puts "Your broadcast address is #{params[:broadcast]}"
  puts "Your gateway address is #{params[:gateway]}"

  hostname = `sudo su -c 'echo #{params[:hostname]} > /etc/hostname && hostname #{params[:hostname]}'`

  old_ip = NetworkInterface.addresses('eth0')[2].first["addr"]
  add_ip = `sudo ip addr add #{params[:ip]}/#{params[:cidr]} dev #{params[:interface]}`
  delete_ip = `sudo ip addr delete #{old_ip}/#{params[:cidr]} dev #{params[:interface]}`

  gateway = `sudo ip route add default via #{params[:gateway]}`

  redirect '/secure/bowser'
end

post '/secure/ping' do
  ping = `ping -q -c 3 8.8.8.8`
  exit = $?.exitstatus
  if exit == 0
    redirect '/secure/good_ping'
    puts "good ping"
  else
    redirect '/secure/bad_ping'
    puts "bad ping"
  end
end

get '/secure/good_ping' do
  slim :good_ping
end

get '/secure/bad_ping' do
  slim :bad_ping
end

post '/logout' do
  session.delete(:identity)
  redirect '/logged/out'
end

get '/logged/out' do
  slim :logged_out
end
