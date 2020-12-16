#!/bin/sh

# Test application benchmarks
./app_test_all.sh
echo ""

# Test CDSChecker data structure benchmarks
cd cdschecker_modified_benchmarks
./test_all.sh
cd ..
echo ""

# Test data structures with bugs that tsan11/tsan11rec cannot detect
cd tsan11-missingbug
./test_all.sh
cd ..
echo ""

# Test assertion failures in Silo and Mabain
./app_assertion_test.sh
