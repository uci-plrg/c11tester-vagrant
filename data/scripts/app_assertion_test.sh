#!/bin/bash
  
C11TESTERLIB="/home/vagrant/c11tester"
C11TESTER_RELAXED_LIB="/home/vagrant/c11tester-relaxed"

MABAINLIB="../src"
MABAINDIR="mabain/examples"

TESTS="silo mabain"

TOTAL_RUN=$1

if [ -z "$1" ]; then
        TOTAL_RUN=10
fi

function run_silo_test {
	export C11TESTER='-x1'
	export LD_LIBRARY_PATH="${C11TESTER_RELAXED_LIB}"

	COUNT_ASSERT=0
	EXE='./dbtest --verbose -t 5'

	cd 'silo/out-perf.debug.check.masstree/benchmarks/'
	for i in `seq 1 1 $TOTAL_RUN`
	do
		OUTPUT="$($EXE 2>&1)"
		ASSERT="$(echo "$OUTPUT" | grep "Assert")"
		if [ -n "$ASSERT" ] ; then
			((++COUNT_ASSERT))
		fi
	done

	rm C11FuzzerTmp* 2> /dev/null
	cd ../../..

	AVG_ASSERT=$(echo "${COUNT_ASSERT} * 100 / ${TOTAL_RUN}" | bc -l | xargs printf "%.1f")
	echo "Runs: ${TOTAL_RUN} | Assertions: ${COUNT_ASSERT} | Assertion rate: ${AVG_ASSERT}%"
}

function run_mabain_test {
	export C11TESTER='-x1'
	export LD_LIBRARY_PATH="${C11TESTERLIB}:${MABAINLIB}"

	COUNT_ASSERT=0
	EXE='./mb_multi_thread_insert_test_assert'

	cd ${MABAINDIR}
	for i in `seq 1 1 $TOTAL_RUN`
	do
		OUTPUT="$(/usr/bin/time -f "time: %E" $EXE 2>&1)"
		ASSERT="$(echo "$OUTPUT" | grep "Assert")"
		if [ -n "$ASSERT" ] ; then
			((++COUNT_ASSERT))
		fi

		rm ./multi_test/* 2> /dev/null
	done

	rm C11FuzzerTmp* 2> /dev/null
	cd ../..

	AVG_ASSERT=$(echo "${COUNT_ASSERT} * 100 / ${TOTAL_RUN}" | bc -l | xargs printf "%.1f")
	echo "Runs: ${TOTAL_RUN} | Assertions: ${COUNT_ASSERT} | Assertion rate: ${AVG_ASSERT}%"
}

echo "** Assertion test for some application benchmarks: ${TESTS} **"
for t in ${TESTS}
do
	echo -n "${t} "
	run_${t}_test
done
