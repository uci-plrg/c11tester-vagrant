#!/bin/bash
set -e
cd ~

# 1. Getting and compiling llvm
sh /vagrant/data/scripts/get-llvm.sh

# 2. Getting and compiling c11tester
git clone git://plrg.ics.uci.edu/c11tester.git
cd ~/c11tester
git checkout vagrant
make clean
make
cd ..

## This version of c11tester compiles volatiles into relaxed atomics
git clone git://plrg.ics.uci.edu/c11tester.git c11tester-relaxed
cd ~/c11tester-relaxed
git checkout vagrant
sed -i 's/memory_order_acquire/memory_order_relaxed/g' config.h
sed -i 's/memory_order_release/memory_order_relaxed/g' config.h
make clean
make
cd ..

# 3. Benchmarks
git clone git://plrg.ics.uci.edu/c11concurrency-benchmarks.git c11tester-benchmarks
cd c11tester-benchmarks
git checkout vagrant
cp /vagrant/data/scripts/build.sh .
cp /vagrant/data/scripts/do_test_all.sh .
cp /vagrant/data/scripts/app_assertion_test.sh .
cp /vagrant/data/scripts/app_test_all.sh .
cp /vagrant/data/scripts/run.sh .
cp /vagrant/data/scripts/calculator.py .
./build.sh
cd ..

## Firefox Javascript shell
cp /vagrant/data/scripts/build_firefox_jsshell.sh .
chmod +x build_firefox_jsshell.sh
./build_firefox_jsshell.sh
echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
