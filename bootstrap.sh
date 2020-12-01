#!/usr/bin/env bash
cd ~/
sudo apt-get update
sudo apt-get -y install cmake g++ clang
git clone https://github.com/llvm/llvm-project.git
ret=$?
if ! test "$ret" -eq 0
	git clone ssh://plrg.ics.uci.edu/home/git/PMCPass.git
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
	cmake -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" ../llvm
	make
	cd ~/
	touch llvm-project/build/lib/libPMCPass.so

then
	echo >&2 "Clonning of llvm-project failed with status $ret. Maybe the folder exists already?"
fi

git clone ssh://plrg.ics.uci.edu/home/git/pmcheck.git
ret=$?
if ! test "$ret" -eq 0
	cd pmcheck/
	git checkout b4a60d7110e7d5f8849c771b84ee09c81e216186
	make
	cd ~/
then
	echo >&2 "Clonning of Jaaru (pmcheck) failed with status $ret. Maybe the folder exists already?"
fi

git clone ssh://plrg.ics.uci.edu/home/git/nvm-benchmarks.git
ret=$?
if ! test "$ret" -eq 0
	cd nvm-benchmarks
	git checkout 4fb82ecb29cdec628630f9433c58813f44aabf90
	cd ~/
then
	echo >&2 "Clonning of nvm-benchmarks failed with status $ret. Maybe the folder exists already?"
fi

echo >&2 "Setup is now compelte. To run the benchmarks, please look at our README.md"
