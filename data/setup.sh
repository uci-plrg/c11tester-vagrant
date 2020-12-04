#!/bin/bash
set -e

# 1. Getting all the source code
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout 7899fe9da8d8df6f19ddcbbb877ea124d711c54b
cd ..

git clone /vagrant/PMCPass.git
cd PMCPass
git checkout vagrant
cd ..

git clone /vagrant/pmcheck.git
cd pmcheck/
git checkout vagrant
cd ..

git clone /vagrant/nvm-benchmarks.git
cd nvm-benchmarks
git checkout vagrant
cd ..


# 2. Compiling the projects
mv PMCPass llvm-project/llvm/lib/Transforms/
echo "add_subdirectory(PMCPass)" >> llvm-project/llvm/lib/Transforms/CMakeLists.txt
cd llvm-project
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Unix Makefiles" ../llvm
make -j 4
cd ~/
touch llvm-project/build/lib/libPMCPass.so

cd pmcheck/
sed -i 's/LLVMDIR=.*/LLVMDIR=~\/llvm-project\//g' Test/gcc
sed -i 's/JAARUDIR=.*/JAARUDIR=~\/pmcheck\/bin\//g' Test/gcc

sed -i 's/LLVMDIR=.*/LLVMDIR=~\/llvm-project\//g' Test/g++
sed -i 's/JAARUDIR=.*/JAARUDIR=~\/pmcheck\/bin\//g' Test/g++
#make
#make test
cd ~/

cp -r pmcheck pmcheck-vmem
cd pmcheck-vmem
sed -i 's/JAARUDIR=.*/JAARUDIR=~\/pmcheck-vmem\/bin\//g' Test/gcc
sed -i 's/JAARUDIR=.*/JAARUDIR=~\/pmcheck-vmem\/bin\//g' Test/g++
sed -i 's/.*\#define ENABLE_VMEM.*/\#define ENABLE_VMEM/g' config.h
make clean
make
make test
cd ~/

cd nvm-benchmarks
sed -i 's/export LD_LIBRARY_PATH=.*/export LD_LIBRARY_PATH=~\/pmcheck-vmem\/bin\//g' run
cd RECIPE

#Initializing CCEH
cd CCEH
sed -i 's/CXX := \/.*/CXX := ~\/pmcheck-vmem\/Test\/g++/g' Makefile
make
cd ..

#Initializing FAST_FAIR
cd FAST_FAIR
sed -i 's/CXX=.*/CXX=~\/pmcheck-vmem\/Test\/g++/g' Makefile
make
cd ..

#initializing P-ART, P-BwTree, P-CLHT, P-Masstree, and P-HOT
RECIPE_BENCH="P-ART P-BwTree P-CLHT P-Masstree"
for bench in $RECIPE_BENCH; do
        cd $bench
        sed -i 's/set(CMAKE_C_COMPILER .*)/set(CMAKE_C_COMPILER "\/home\/vagrant\/pmcheck-vmem\/Test\/gcc")/g' CMakeLists.txt
        sed -i 's/set(CMAKE_CXX_COMPILER .*)/set(CMAKE_CXX_COMPILER "\/home\/vagrant\/pmcheck-vmem\/Test\/g++")/g' CMakeLists.txt
        sed -i 's/export LD_LIBRARY_PATH=.*/export LD_LIBRARY_PATH=~\/pmcheck-vmem\/bin\//g' run.sh
        sed -i 's/export DYLD_LIBRARY_PATH=.*/export DYLD_LIBRARY_PATH=~\/pmcheck-vmem\/bin\//g' run.sh
        rm -rf build
        mkdir build
        cd build
        cmake -DCMAKE_C_COMPILER=/home/vagrant/pmcheck-vmem/Test/gcc -DCMAKE_CXX_COMPILER=/home/vagrant/pmcheck-vmem/Test/g++ -DCMAKE_C_FLAGS=-fheinous-gnu-extensions ..
        make -j
        touch run.sh
        cd ../../
done


bash runall

echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
