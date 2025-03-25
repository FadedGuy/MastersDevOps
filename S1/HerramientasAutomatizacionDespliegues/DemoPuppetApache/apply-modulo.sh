#!/bin/bash

sudo mkdir -p /vagrant
sudo /opt/puppetlabs/bin/puppet apply --modulepath=./modules -e "include apache"

