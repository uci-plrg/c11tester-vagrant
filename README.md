# C11Tester-vagrant

## Building C11Tester and benchmarks using Vagrant

1. In order for Vagrant to run, we should first make sure that the [VT-d option for virtualization is enabled in BIOS](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).

2. Then, we should download and install Vagrant, if we do not have Vagrant ready on our machine.

```
    $ sudo apt-get install virtualbox
    $ sudo apt-get install vagrant
```

3. We also need to check out this repository into our machine.

```
    $ git clone https://github.com/uci-plrg/c11tester-vagrant.git
```

4. Next, we run Vagrant inside the **c11tester-vagrant** folder.  Vagrant will download C11Tester, our LLVM pass, and our benchmarks.

```
    c11tester-vagrant $ vagrant up
```

5. When the provisioning is done and Vagrant is up, we need to ssh into the running Vagrant VM.

```
    c11tester-vagrant $ vagrant ssh
```

## Running C11Tester benchmarks

Our benchmarks fall into three categories: application benchmarks, data structure benchmarks (CDSChecker data structure benchmarks) used to evaluate CDSChecker, and data structure benchmarks with injected bugs that both tsan11 and tsan11rec miss.

In the benchmark directory (`~/c11tester-benchmarks`), the application benchmarks include Gdax (`gdax-orderbook-hpp`), Iris (`iris`), Mabain (`mabain`), Silo (`silo`), and the Javascript Engine of Firefox that runs Jsbench (`jsbench-2013.1`).  The `c11tester-benchmarks` repository does not contain the Javascript Engine of Firefox, but the setup scripts downloaded Firefox, compiled the Javascript Engine, and copy the Javascript Engine binary into the benchmark directory (`c11tester-benchmarks/js`) by running the script `build_firefox_jsshell.sh`.

The `c11tester-benchmarks/cdschecker_modified_benchmarks` directory contains data structure benchmarks used to evaluate CDSChecker.  The `c11tester-benchmarks/tsan11-missingbug` directory contains data structure benchmarks with bugs that tsan11 and tsan11rec fail to detect. 

### To run application benchmarks:

```
    cd ~/c11tester-benchmarks
    ./test_all.sh [number of runs]
```
The `c11tester-benchmarks/test_all.sh` script runs all of five application benchmarks in both the all-core and single-core configurations.  The `test_all.sh` script also accepts an integer as an optional parameter that specifies how many times each application benchmark is run, such as `./test_all.sh 5`.  It runs all of five application benchmarks 10 times by default.  After finish running the application benchmarks, the `test_all.sh` script executes `python calculator.py all-core` or `python calculator.py single-core` in the `c11tester-benchmarks` directory to print out results. 

### To run CDSChecker data structure benchmarks:

```
    cd ~/c11tester-benchmarks/cdschecker_modified_benchmarks
    ./test_all.sh
```

The `cdschecker_modified_benchmarks/test_all.sh` script tests seven data structures for 500 runs and reports data race detection rates and execution time for each data structure.  The results are printed in the console. 

### To run data structure benchmarks with bugs that tsan11 and tsan11rec miss:

```
    cd ~/c11tester-benchmarks/tsan11-missingbug
    ./test_all.sh
```

The `tsan11-missingbug/test_all.sh` script tests two buggy data structure implementations for 1000 runs and reports assertion detection rates and execution time for each data structure.  The results are printed in the console.

### Compile and run your own test cases inside of the VM
You need to compile your tool with C11Tester and our LLVM pass (i.e., CDSPass). To make this process easier, we provide four scripting files g++, gcc, clang, and clang++ under the 'c11tester-benchmarks' folder.  In each of these files we define appropriate flags for the compiler.  You can modify '/home/vagrant/llvm/build/bin/clang', '/home/vagrant/llvm/build/lib/libCDSPass.so', and '/home/vagrant/c11tester' in these files to point to the location of clang (clang++), LLVM and C11Tester on your machine.  Then, modify the building system of your tool to use these script wrappers instead of the actual compilers. For example, your '~/c11tester-benchmarks/g++' file can look like this:

```
    /home/vagrant/llvm/build/bin/clang++ -Xclang -load -Xclang /home/vagrant/llvm/build/lib/libCDSPass.so -L/home/vagrant/c11tester -lmodel -Wno-unused-command-line-argument $@
```


## Disclaimer

We make no warranties that C11Tester is free of errors. Please read the paper and the README file so that you understand what the tool is supposed to do.

## Contact

Please feel free to contact us for more information. Bug reports are welcome, and we are happy to hear from our users. Contact Weiyu Luo at [weiyul7@uci.edu](mailto:weiyul7@uci.edu) or Brian Demsky at [bdemsky@uci.edu](mailto:bdemsky@uci.edu) for any questions about C11Tester. 
