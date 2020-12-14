#!/bin/bash
set -e
cd ~

# 1. Getting and compiling llvm
sh /vagrant/data/scripts/get-llvm.sh

# 2. Getting and compiling c11tester
git clone git://plrg.eecs.uci.edu/c11tester.git
cd ~/c11tester
git checkout vagrant
make clean
make
cd ..

# 3. Benchmarks
git clone git://plrg.eecs.uci.edu/c11concurrency-benchmarks.git c11tester-benchmarks
cd c11tester-benchmarks
git checkout vagrant
cp /vagrant/data/scripts/build.sh .
cp /vagrant/data/scripts/test_all.sh .
cp /vagrant/data/scripts/run.sh .
sh build.sh
cd ..

## Firefox Javascript shell
cp /vagrant/data/scripts/build_firefox_jsshell.sh .
sh build_firefox_jsshell.sh
echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
