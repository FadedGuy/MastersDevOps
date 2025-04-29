#!/bin/bash

sudo mkdir -p /vagrant

sudo /opt/chef/bin/chef-solo -c solo.rb -j node.json 