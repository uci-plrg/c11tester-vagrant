#!/bin/bash
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
make
cd ~/

git clone /vagrant/nvm-benchmarks.git
cd nvm-benchmarks
git checkout 4fb82ecb29cdec628630f9433c58813f44aabf90
cd ~/

echo >&2 "Setup is now complete. To run the benchmarks, please look at our READE.md"
