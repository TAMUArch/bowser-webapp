require_relative 'bowser/config'

module Bowser
  extend self

  def save_config(config)
    File.open("./location/of/file", 'w') do |f|
      f.puts(JSON.pretty_generate(network.to_hash))
    end
  end

  def return_config(config)
    conf = Config.new(config)
    if File.exists?("./location/of/file/.json")
      c = JSON.parse(IO.read("./location/of/file/.json"))
      conf.hostname = c['hostname']
      conf.domain = c['domain']
      conf.interface = c['interface']
      conf.netmask = c['netmask']
      conf.cidr = c['cidr']
      conf.broadcast = c['broadcast']
      conf.gateway = c['gateway']
    end
    conf
  end
end
