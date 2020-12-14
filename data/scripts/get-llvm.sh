#!/bin/sh
set -e

# Getting and compiling llvm for c11tester
cd ~
if [ ! -d "llvm" ]; then
	wget https://releases.llvm.org/8.0.0/llvm-8.0.0.src.tar.xz
	tar -xf llvm-8.0.0.src.tar.xz
	mv llvm-8.0.0.src llvm
	rm llvm-8.0.0.src.tar.xz
fi

wget https://releases.llvm.org/8.0.0/cfe-8.0.0.src.tar.xz
tar -xf cfe-8.0.0.src.tar.xz
mv cfe-8.0.0.src clang
rm cfe-8.0.0.src.tar.xz

git clone git://plrg.eecs.uci.edu/c11llvm.git CDSPass
cd CDSPass
git checkout vagrant

cd ~
mv CDSPass ~/llvm/lib/Transforms/
mv clang ~/llvm/tools
echo "add_subdirectory(CDSPass)" >> llvm/lib/Transforms/CMakeLists.txt
echo "add_dependencies(CDSPass intrinsics_gen)" >> llvm/lib/Transforms/CMakeLists.txt
cd llvm
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Unix Makefiles" ..
make -j 6
