#! /bin/sh

if [ -z $1 ] ; then
	echo "usage: $0 <dirname>"
elif [ -d $1 ] ; then
	echo "directory $1 already exists"
else
	autoconf2.13
	mkdir $1
	cd $1
	LLVM_ROOT="/scratch/llvm"
	CC="/home/vagrant/llvm/build/bin/clang" \
	CXX="/home/vagrant/llvm/build/bin/clang++" \
	CFLAGS="-Xclang -load -Xclang /home/vagrant/llvm/build/lib/libCDSPass.so -L/home/vagrant/c11tester -lmodel" \
	CXXFLAGS="-Xclang -load -Xclang /home/vagrant/llvm/build/lib/libCDSPass.so -L/home/vagrant/c11tester -lmodel" \
	LDFLAGS="-Xclang -load -Xclang /home/vagrant/llvm/build/lib/libCDSPass.so -L/home/vagrant/c11tester -lmodel" \
			../configure --disable-debug --enable-optimize="-O2 -gline-tables-only" --enable-llvm-hacks --disable-jemalloc
	make -j 8
fi
