#!/bin/bash
set -e

# 1. Getting and compiling llvm for c11tester
wget https://releases.llvm.org/8.0.0/llvm-8.0.0.src.tar.xz
tar -xf llvm-8.0.0.src.tar.xz
mv llvm-8.0.0.src llvm
rm llvm-8.0.0.src.tar.xz

wget https://releases.llvm.org/8.0.0/cfe-8.0.0.src.tar.xz
tar -xf cfe-8.0.0.src.tar.xz
mv cfe-8.0.0.src clang
rm cfe-8.0.0.src.tar.xz

git clone git://plrg.eecs.uci.edu/c11llvm.git CDSPass
cd CDSPass
git checkout vagrant

cd ~
mv CDSPass c11tester_llvm/lib/Transforms/
mv clang c11tester_llvm/tools
echo "add_subdirectory(CDSPass)" >> c11tester_llvm/lib/Transforms/CMakeLists.txt
echo "add_dependencies(CDSPass intrinsics_gen)" >> c11tester_llvm/lib/Transforms/CMakeLists.txt
cd c11tester_llvm
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Unix Makefiles" ..
make -j 4

# 
git clone git://plrg.eecs.uci.edu/c11tester.git
cd c11tester
cd ..

git clone git://plrg.eecs.uci.edu/c11concurrency-benchmarks.git
cd c11concurrency-benchmarks
git checkout vagrant
cd ..

cd ~/c11tester
make clean
make

# Benchmarks
## Firefox
cd ~/c11concurrency-benchmarks
wget https://ftp.mozilla.org/pub/firefox/releases/50.0.1/source/firefox-50.0.1.source.tar.xz
tar -xf firefox-50.0.1.source.tar.xz
mv firefox-50.0.1 firefox
rm firefox-50.0.1.source.tar.xz
cp firefox-related/jsshell-c11tester.sh firefox/js/src
cp firefox-related/icu.m4 build/autoconf
cd firefox/js/src
sh jsshell-c11tester.sh c11tester

# Other benchmarks
cd ~/c11concurrency-benchmarks/mabain
make clean
make install
cd examples
make
mkdir multi_test

cd ~/c11concurrency-benchmarks/gdax-orderbook-hpp/demo
make clean
make

cd ~/c11concurrency-benchmarks/iris
make clean
make
make test

cd ~/c11concurrency-benchmarks/silo
make clean;
MODE=perf CHECK_INVARIANTS=0 USE_MALLOC_MODE=0 make -j dbtest

echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
