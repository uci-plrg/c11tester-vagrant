#!/bin/sh

# Download firefox
cd ~
if [ ! -d "firefox" ]; then
	wget https://ftp.mozilla.org/pub/firefox/releases/50.0.1/source/firefox-50.0.1.source.tar.xz
	tar -xf firefox-50.0.1.source.tar.xz
	mv firefox-50.0.1 firefox
	rm firefox-50.0.1.source.tar.xz
fi

cp /vagrant/data/scripts/jsshell-c11tester.sh firefox/js/src
cp /vagrant/data/scripts/icu.m4 /home/vagrant/firefox/build/autoconf
cd /home/vagrant/firefox/js/src

if [ -d "c11tester" ]; then rm -Rf c11tester; fi
sh jsshell-c11tester.sh c11tester
cp c11tester/js/src/shell/js /home/vagrant/c11tester-benchmarks
