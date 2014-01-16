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
