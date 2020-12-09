#!/bin/bash
apt-get update
apt-get -y install cmake g++ autoconf2.13 python libreadline-dev libssl-dev libncurses-dev
apt-get -y install libnuma-dev libdb++-dev libz-dev libboost-dev libboost-system-dev

su -c /vagrant/data/setup.sh vagrant
