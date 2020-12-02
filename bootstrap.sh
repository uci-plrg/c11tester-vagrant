#!/bin/bash
apt-get update
apt-get -y install cmake g++ clang

su -c /vagrant/data/setup.sh vagrant
