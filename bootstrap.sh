#!/bin/bash
apt-get update
apt-get -y install cmake g++ autoconf autoconf2.13 libreadline-dev libssl-dev libncurses-dev
apt-get -y install libnuma-dev libdb++-dev libz-dev libboost-dev libboost-system-dev libaio-dev
apt-get -y install python python-pip
pip install statistics

su -c /vagrant/data/scripts/setup.sh vagrant
