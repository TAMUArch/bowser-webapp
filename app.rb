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

  config = false

  unless `hostname`.chomp == params[:hostname]
    hostname = `sudo su -c 'echo #{params[:hostname]} > /etc/hostname && hostname #{params[:hostname]}'`
    puts "Your hostname is #{params[:hostname]}"
    config = true
  else
    puts "hostname input unchanged"
  end

  old_ip = NetworkInterface.addresses('eth0')[2].first["addr"]

  unless old_ip == params[:ip]
    add_ip = `sudo ip addr add #{params[:ip]}/#{params[:cidr]} dev #{params[:interface]}`
    delete_ip = `sudo ip addr delete #{old_ip}/#{params[:cidr]} dev #{params[:interface]}`
    puts "Your ip address is #{params[:ip]}"
    puts "Your interface is #{params[:interface]}"
    config = true
  else
    puts "ip input unchanged"
  end

  old_net = NetworkInterface.addresses('eth0')[2].first["netmask"]

  unless old_net == params[:netmask]
    netmask = `sudo ifconfig #{params[:interface]} netmask #{params[:netmask]}`
    puts "Netmask in cidr #{params[:cidr]}"
    puts "Your netmask is #{params[:netmask]}"
    config = true
  else
    puts "netmask input unchanged"
  end

  unless gateway == params[:gateway]
    permit = `sudo ip link set dev eth0`
    gateway = `sudo ip route add default via #{params[:gateway]}`
    puts "Your gateway address is #{params[:gateway]}"
    config = true
  else
    puts "gateway input unchanged"
  end

  old_broad = NetworkInterface.addresses('eth0')[2].first["broadcast"]

  unless old_broad == params[:broadcast]
    broadcast = `sudo ifconfig #{params[:interface]} broadcast #{params[:broadcast]}`
    puts "Your broadcast address is #{params[:broadcast]}"
    config = true
  else
    puts "broadcast input unchanged"
  end

  if config == true
    config1 = `touch network@#{params[:interface]}`
    config2 = `touch network@.service`

    echo1 = `echo "address=#{params[:ip]}
                  netmask=#{params[:cidr]}
                  broadcast=#{params[:broadcast]}
                  gateway=#{params[:gateway]}" > network@#{params[:interface]}`

    echo2 = `echo "[Unit]
                  Description=Network connectivity (%i)
                  Wants=network.target
                  Before=network.target
                  BindsTo=sys-subsystem-net-devices-%i.device
                  After=sys-subsystem-net-devices-%i.device

                  [Service]
                  Type=oneshot
                  RemainAfterExit=yes
                  EnvironmentFile=/etc/conf.d/network@%i

                  ExecStart=/usr/bin/ip link set dev %i up
                  ExecStart=/usr/bin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev %i
                  ExecStart=/usr/bin/ip route add default via ${gateway}

                  ExecStop=/usr/bin/ip addr flush dev %i
                  ExecStop=/usr/bin/ip link set dev %i down

                  [Install]
                  WantedBy=multi-user.target" > network@.service`
    enable = `systemctl enable network@#{params[:interface]}.service`
    start = `systemctl start network@#{params[:interface]}.service`
  end
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
