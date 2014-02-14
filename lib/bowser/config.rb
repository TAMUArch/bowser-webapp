module Bowser
  class Config
    attr_accessor :hostname, :ip, :interface, :netmask, :cidr, :broadcast, :gateway

    def initialize(config, options = {})
      @hostname = options['hostname']
      @ip = options['ip']
      @interface = options['interface']
      @netmask = options['netmask']
      @cidr = options['cidr']
      @broadcast = options['broadcast']
      @gateway = options['gateway']
    end

    def to_hash
      {
        'hostname' => @hostname,
        'domain' => @domain,
        'interface' => @interface,
        'netmask' => @netmask,
        'cidr' => @cidr,
        'broadcast' => @broadcast,
        'gateway' => @gateway
      }
    end
  end
end
