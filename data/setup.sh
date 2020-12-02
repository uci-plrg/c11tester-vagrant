#!/bin/bash
set -e

git clone https://github.com/llvm/llvm-project.git

git clone /vagrant/PMCPass.git
cd llvm-project
git checkout 7899fe9da8d8df6f19ddcbbb877ea124d711c54b
cd ../PMCPass
git checkout 0b639997a1a990cfaa0adb29a4f3a1c9f784d8ca
cd ~/
mv PMCPass llvm-project/llvm/lib/Transforms/
echo "add_subdirectory(PMCPass)" >> llvm-project/llvm/lib/Transforms/CMakeLists.txt
cd llvm-project
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Release -G "Unix Makefile" ../llvm
make
cd ~/
touch llvm-project/build/lib/libPMCPass.so

git clone /vagrant/pmcheck.git
cd pmcheck/
git checkout b4a60d7110e7d5f8849c771b84ee09c81e216186
sed -i 's/LLVMDIR=.*/LLVMDIR=~\/llvm-project\//g' Test/gcc
#sed -i 's/CC=.*/CC=clang/g' Test/gcc
sed -i 's/JAARUDIR=.*/JAARUDIR=~\/pmcheck\/bin\//g' Test/gcc

sed -i 's/LLVMDIR=.*/LLVMDIR=~\/llvm-project\//g' Test/g++
#sed -i 's/CC=.*/CC=clang++/g' Test/g++
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

git clone /vagrant/nvm-benchmarks.git
cd nvm-benchmarks
git checkout 4fb82ecb29cdec628630f9433c58813f44aabf90
sed -i 's/export LD_LIBRARY_PATH=.*/export LD_LIBRARY_PATH=~\/pmcheck\/bin\//g' run
cd RECIPE
#Initializing CCEH
cd CCEH
sed -i 's/CXX := \/.*/CXX := ~\/pmcheck-vmem\/Test\/g++/g' Makefile
make
#Initializing FAST_FAIR
cd ../FAST_FAIR
sed -i 's/CXX=.*/CXX=~\/pmcheck-vmem\/Test\/g++/g' Makefile
make

RECIPE_BENCH="P-ART P-BwTree P-CLHT P-Masstree P-HOT"
for bench in $RECIPE_BENCH; do
	cd bench
	sed -i 's/set(CMAKE_C_COMPILER .*)/set(CMAKE_C_COMPILER "\/home\/vagrant\/pmcheck-vmem\/Test\/gcc")/g' CMakeLists.txt
	sed -i 's/set(CMAKE_CXX_COMPILER .*)/set(CMAKE_CXX_COMPILER "\/home\/vagrant\/pmcheck-vmem\/Test\/g++")/g' CMakeLists.txt
	sed -i 's/export LD_LIBRARY_PATH=.*/export LD_LIBRARY_PATH=~\/pmcheck-vmem\/bin\//g' run.sh
	sed -i 's/export DYLD_LIBRARY_PATH=.*/export DYLD_LIBRARY_PATH=~\/pmcheck-vmem\/bin\//g' run.sh
	mkdir build
	cd build
	cmake -DCMAKE_C_COMPILER=/home/vagrant/pmcheck-vmem/Test/gcc -DCMAKE_CXX_COMPILER=/home/vagrant/pmcheck-vmem/Test/g++ -DCMAKE_CXX_FLAGS=-fheinous-gnu-extensions ..
	make -j
	cd ../../
done
cd ~/

echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
