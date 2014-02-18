require_relative 'bowser/config'

module Bowser
  extend self

  def save_config(config)
    File.open("./var/chef/data_bags/config.json", 'w') do |f|
      f.puts(JSON.pretty_generate(network.to_hash))
    end
  end

  def return_config(config)
    conf = Config.new(config)
    if File.exists?("./var/chef/data_bags/config.json")
      c = JSON.parse(IO.read("./var/chef/data_bags/config.json"))
      conf.hostname = c['hostname']
      conf.domain = c['domain']
      conf.interface = c['interface']
      conf.netmask = c['netmask']
      conf.broadcast = c['broadcast']
      conf.gateway = c['gateway']
    end
    conf
  end
end
