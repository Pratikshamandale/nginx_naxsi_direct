#
# Cookbook Name:: ngnix_naxsi_direct
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute



execute 'apt-get update' do
  command "sudo apt-get update"
  action :run
end


#install the 'Development tools' package group
%w[build-essential libpcre3 libpcre3-dev openssl libssl-dev unzip].each do |pkg|
  package pkg do
    action :install
  end
end

#install nginx-naxsi
execute 'apt-get install nginx-naxsi' do
  command "sudo apt-get install nginx-naxsi -y"
  action :run
end

#create nginx cache directory
directory node['nginx-naxsi']['nginx_cache_dir'] do
  action :create
  recursive true
end

#create ssl directory
directory node['nginx-naxsi']['nginx_ssl'] do
  action :create
  recursive true
end


#create and Copy nginx init file
cookbook_file "/etc/nginx/ssl/nginx.crt" do
  source "nginx.crt.erb"
  owner "root"
  group "root"
  mode  "0755"
  action :create
end


#create and Copy nginx init file
cookbook_file "/etc/nginx/ssl/nginx.key" do
  source "nginx.key.erb"
  owner "root"
  group "root"
  mode  "0755"
  action :create
end



#create and Copy nginx init file
cookbook_file "/etc/init.d/nginx" do
  source "nginx.init.j2"
  owner "root"
  group "root"
  mode  "0755"
  action :create
end

#Copy naxsi.rules file
cookbook_file "/etc/nginx/naxsi.rules" do
  source "naxsi.rules.j2"
  owner "root"
  group "root"
  mode  "0644"
  action :create
end

#Copy naxsi_core.rules file (customized)
cookbook_file "/etc/nginx/naxsi_core.rules" do
  source "naxsi_core.rules.j2"
  owner "root"
  group "root"
  mode  "0644"
  action :create
end

#Copy ngingx.conf
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  variables({
    :hostname => node['nginx-naxsi']['hostname'],
    :backend_server => node['nginx-naxsi']['backend_server'] ,
    :webapps_path => node['nginx-naxsi']['webapps_path']
  })
  owner "root"
  group "root"
  mode  "0644"
end

