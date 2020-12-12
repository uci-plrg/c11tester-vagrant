#!/bin/bash

TOTAL_RUN=$1

if [ -z "$1" ]; then
        TOTAL_RUN=10
fi

# Clear data
rm *.log 2> /dev/null

echo "test application benchmarks"
# Run in all-core configuration
if [ ! -d "all-core" ]; then
	mkdir all-core
fi

echo "running each benchmark with multiple cores for ${TOTAL_RUN} times"
rm all-core/*.log 2> /dev/null
./run.sh $TOTAL_RUN
mv *.log all-core
echo "done"
python calculator.py all-core

# Run in single-core configuration
if [ ! -d "single-core" ]; then
	mkdir single-core
fi

echo "running each benchmark with a single core for ${TOTAL_RUN} times"
rm single-core/*.log 2> /dev/null
taskset -c 0 ./run.sh $TOTAL_RUN
mv *.log single-core
echo "done"
python calculator.py single-core

