name             "chef-kibana-ruby"
maintainer       "James Brook"
maintainer_email "YOUR_EMAIL"
license          "Apache License, Version 2.0"
description      "Installs/Configures kibana (ruby version)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

supports         "ubuntu"
supports         "debian"

supports         "redhat"
supports         "centos"
supports         "scientific"
supports         "amazon"
supports         "fedora"
 
depends "runit"
depends "apt"
depends "yum"
depends "rbenv"
depends "ruby_build"

