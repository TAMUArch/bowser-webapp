module Bowser
  class Config
    attr_accessor :id, :hostname, :ip, :interface, :netmask, :broadcast, :gateway

    def initialize(config, options = {})
      @id = options['id']
      @hostname = options['hostname']
      @ip = options['ip']
      @interface = options['interface']
      @netmask = options['netmask']
      @broadcast = options['broadcast']
      @gateway = options['gateway']
    end

    def to_hash
      {
        'id' => @id,
        'hostname' => @hostname,
        'domain' => @domain,
        'interface' => @interface,
        'netmask' => @netmask,
        'broadcast' => @broadcast,
        'gateway' => @gateway
      }
    end
  end
end
