#
# Cookbook Name:: bowser
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
#

node.override[:set_fqdn] = data_bag_item('host', 'network')["hostname"]

include_recipe "hostname"

ifconfig data_bag_item('host', 'network')["oldip"] do
  target data_bag_item('host', 'network')["newip"]
  device data_bag_item('host', 'network')["interface"]
  mask data_bag_item('host', 'network')["netmask"]
  bcast data_bag_item('host', 'network')["broadcast"]

end

