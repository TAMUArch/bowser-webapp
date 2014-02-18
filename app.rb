require 'rubygems'
require 'sinatra'
require 'slim'
require 'yaml'
require 'sinatra/contrib'
require 'network_interface'
require 'unicorn'

config_file 'config.yml'

configure do
# uncomment for use with vagrant
# set :bind, '0.0.0.0'
  set :port, '80'
  enable :sessions
  Slim::Engine.set_default_options pretty: true, sort_attrs: false
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

  def networkname
    network = `ip route show | grep default`
    name = network.split(' ')
    @networkname = name[4]
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
    conf = return_config(params['config'])
    conf.hostname = params['hostname']
    conf.ip = params['ip']
    conf.interface = params['interface']
    conf.netmask = params['netmask']
    conf.broadcast = params['broadcast']
    conf.gateway = params['gateway']
    save_config(conf)
    redirect '/secure/bowser'
end

post '/secure/ping' do
  ping = `ping -q -c 3 8.8.8.8`
  exit = $?.exitstatus
  if exit == 0
    redirect '/secure/good_ping'
    puts 'good ping'
  else
    redirect '/secure/bad_ping'
    puts 'bad ping'
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
