#!/bin/sh

# Mabain
cd ~/c11tester-benchmarks/mabain
make clean
rm -r -f examples/multi_test
make install
cd examples
make
mkdir multi_test

# Gdax
cd ~/c11tester-benchmarks/gdax-orderbook-hpp/demo
make clean
make

# Iris
cd ~/c11tester-benchmarks/iris
make clean
make
make test

# Silo
cd ~/c11tester-benchmarks/silo
make clean;
MODE=perf CHECK_INVARIANTS=0 USE_MALLOC_MODE=0 make -j dbtest
