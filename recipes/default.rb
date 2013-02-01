#
# Cookbook Name:: chef-kibana-ruby
# Recipe:: default
include_recipe "runit" unless node["platform_version"] == "12.04"

case node['platform']
when "debian", "ubuntu"
  include_recipe 'apt'
  packages = %w{libcurl4-openssl-dev}
    packages.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat", "centos", "amazon", "fedora", "scientific"
  include_recipe 'yum'
  include_recipe "yum::epel"
  packages = %w{curl-devel}
    packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

group node['kibana']['group'] do
  system true
end

user node['kibana']['user'] do
  home node['kibana']['home']
  gid node['kibana']['group']
  comment "Service user for Kibana web interface"
  supports :manage_home => true
  shell "/bin/bash"
end

package 'git'

git node['kibana']['install'] do
  repository node['kibana']['git']['url']
  reference node['kibana']['git']['reference']
  user node['kibana']['user']
  group node['kibana']['group']
  action :checkout
end

template "Create Kibana config" do
  path "#{node['kibana']['install']}/KibanaConfig.rb"
  source "KibanaConfig.rb.erb"
  owner node['kibana']['user']
  group node['kibana']['group']
  mode 0644
  notifies :restart, "service[kibana]", :delayed
end

execute "kibana owner-change" do
    command "chown -Rf #{node['kibana']['user']}:#{node['kibana']['group']} #{node['kibana']['home']}"
end

include_recipe "ruby_build"
include_recipe "rbenv::system"

rbenv_ruby node['kibana']['ruby_version'] do
  action :install
  root_path node['rbenv']['root_path']
end

rbenv_global node['kibana']['ruby_version'] do
  root_path node['rbenv']['root_path']
end

rbenv_gem "bundler" do
  rbenv_version node['kibana']['ruby_version']
  root_path node['rbenv']['root_path']
end

rbenv_gem "daemons" do
  rbenv_version node['kibana']['ruby_version']
  root_path node['rbenv']['root_path']
end

rbenv_script "bundle_install" do
  rbenv_version node['kibana']['ruby_version']
  cwd           node['kibana']['install']
  root_path     node['rbenv']['root_path']
  code          %{bundle install}
end

if platform?  "debian", "ubuntu"
  if node["platform_version"] == "12.04"
    template "/etc/init/kibana.conf" do
      mode "0644"
      source "kibana.conf.erb"
    end

    service "kibana" do
      provider Chef::Provider::Service::Upstart
      action [ :enable, :start ]
    end
  else
    runit_service "kibana"
  end
elsif platform? "redhat", "centos", "amazon", "fedora", "scientific"
  template "/etc/init.d/kibana" do
    source "init.erb"
    owner "root"
    group "root"
    mode "0774"
    variables(:basedir => "#{node['kibana']['install']}")
  end

  service "kibana" do
    supports :restart => true, :reload => true, :status => true
    action :enable
  end
end
