# chef-kibana-ruby cookbook #

A simple cookbook that installs [Kibana](https://github.com/rashidkpc/Kibana) in the new Ruby version. Kibana is a web frontend for analysing Logstash messages in an Elasticsearch index.

# Requirements #

Kibana requires a working installation of Elasticsearch and Logstash.

This cookbook depends on rvm for providing the Ruby installation. It has been tested on CentOS-6.3-x86_64 so far.

# Attributes #

* `node['kibana']['git']['url']` - The git repo from which Kibana should be checked out.
* `node['kibana']['git']['reference']` - The version of Kibana to download (corresponds to a tag on Github).
* `node[:kibana][:home]` - The home directory for the Kibana system user.
* `node[:kibana][:user]` - System user for Kibana, defaults to `kibana`.
* `node[:kibana][:group]` - System group for Kibana, defaults to `kibana`.
* `node['kibana']['install']` - relative directory under Kibana home. This is where the dist will be checked out to. It has to be a non-existent or empty directory.
* `node[:kibana][:ruby_version]` - RVM Ruby version for Kibana, defaults to `ruby-1.9.3-p125`.
* `node[:kibana][:config]` - A hash of configuration options for Kibana. These match the options available in Kibana's `KibanaConfig.rb` file. See `attributes/default.rb` for more information.

# Recipes #

* `default` - Checs out Kibana Ruby version from Github, creates a system user specifed by the `user` attribute and extracts it inside the install directory specified by the `install` attribute. It then writes the `KibanaConfig.rb` file based on values contained in the `node[:kibana][:config]` attribute namespace.

# License and Author #

- Author:: James Brook
- Author:: Christopher Hlubek (adapted)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
