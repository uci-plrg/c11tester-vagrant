#!/bin/bash
  
C11TESTERLIB="/home/vagrant/c11tester"
GDAXLIB="./dependencies/libcds-2.3.2/build-release/bin"
GDAXDIR="gdax-orderbook-hpp/demo"

MABAINLIB="../src"
MABAINDIR="mabain/examples"

JSBENCH_DIR="jsbench-2013.1"
JSEXE_PATH="/home/vagrant/c11tester-benchmarks/js"

TESTS="gdax silo mabain iris jsbench"

TOTAL_RUN=$1

REDUNDANT="jemalloc.stats log.txt"

function run_gdax_test {
	cd ${GDAXDIR}
	export C11TESTER='-x1 -v1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}:${GDAXLIB}"

	for i in `seq 1 1 $TOTAL_RUN`
	do
		echo "round ${i}"
		./demo 120
	done
	cd ../..
}

function run_silo_test {
	export C11TESTER='-x1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}"

	for i in `seq 1 1 $TOTAL_RUN`
	do
		echo "round ${i}"
		./silo/out-perf.masstree/benchmarks/dbtest --verbose -t 5
	done
}

function run_mabain_test {
	cd ${MABAINDIR}
	export C11TESTER='-x1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}:${MABAINLIB}"

	for i in `seq 1 1 $TOTAL_RUN`
	do
		echo "round ${i}"
		rm ./multi_test/* 2> /dev/null
		time ./mb_multi_thread_insert_test
	done
	cd ../..
}

function run_iris_test {
	export C11TESTER='-x1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}"

	for i in `seq 1 1 $TOTAL_RUN`
	do
		echo "round ${i}"
		time ./iris/test_lfringbuffer
	done
}

function run_jsbench_test {
	cd ${JSBENCH_DIR}

	export C11TESTER='-x1 -v1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}"

	python ./harness.py ${JSEXE_PATH} ${TOTAL_RUN}
	cd ..
}

rm $REDUNDANT 2> /dev/null

echo "Benchmarks: ${TESTS}"
for t in ${TESTS}
do
	rm "${t}.log" 2> /dev/null
	echo "Running ${t}"
	(run_${t}_test 2>&1) > "${t}.log"
done
