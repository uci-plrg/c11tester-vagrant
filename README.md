# jaaru-vagrant


1. In order for Vagrant to run, we should first make sure that the [VT-d option for virtualization is enabled in BIOS](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).

2. Then, we should download and install Vagrant, if we do not have Vagrant ready on our machine.

```
    $ sudo apt-get install virtualbox
    $ sudo apt-get install vagrant
```

3. We also need to check out this repository into our machine.

```
    $ git clone https://github.com/hgorjiara/jaaru-vagrant.git
```

4. Next, we run Vagrant inside the **jaaru-vagrant** folder.  Vagrant will download Jaaru, our LLVM pass, and our benchmarks.

```
    jaaru-vagrant $ vagrant up
```

5. When the provisioning is done and Vagrant is up, we need to ssh into the running Vagrant VM.

```
    jaaru-vagrant $ vagrant ssh
```

6. After logging in into the VM, we need to make some changes to run [RECIPE](github.com/utsaslab/RECIPE) and [PMDK](github.com/pmem/pmdk/) benchmarks. RECIPE uses [libvmemmalloc](https://pmem.io/pmdk/manpages/linux/v1.3/libvmmalloc.3.html) to access persistent memory. To activate libvmemmalloc support in Jaaru, uncomment the following flag in '~/pmcheck/config.h':

```
    #define ENABLE_VMEM
```

7. To run your test cases, you need to compile your tool with Jaaru (i.e., pmcheck) and our LLVM pass (i.e., PMCPass). To make this process easier, we use a coding pattern which is described as follows: If you check 'pmcheck/Test' directory, there are 4 scripting files g++, gcc, clang, and clang++. In each of these files we define appropriate flags for the compiler. You can modify 'LLVMDIR' and 'JAARUDIR' environment variables in these files to point to the location of LLVM and Jaaru (i.e., PMCheck) on your machine. Then, modify the building system of your tool to use these script wrappers instead of the actual compilers. For example, your '~/pmcheck/Test/g++' file can look like this:

```
	LLVMDIR=~/llvm-project/
	CC=${LLVMDIR}/build/bin/clang++
	LLVMPASS=${LLVMDIR}/build/lib/libPMCPass.so
	JAARUDIR=~/pmcheck/bin/
	$CC -Xclang -load -Xclang $LLVMPASS -L${JAARUDIR} -lpmcheck -Wno-unused-command-line-argument -Wno-address-of-packed-member -Wno-mismatched-tags -Wno-unused-private-field -Wno-constant-conversion -Wno-null-dereference $@
```

To verify the script wrappers you can build our test cases without any errors:

```
    cd ~/pmcheck/
    make test
```

8. To compile any RECIPE benchmarks, you need to step 6 and modify the Makefile to change the compiler to point to the corresponding wrapper script. For example, in FAST\_FAIR makefile, one needs to add the following line:

```
    CXX=~/pmcheck/Test/g++
```

9. To run each RECIPE benchmark, you need to replace the 'run' file in 'nvm-benchmarks' directory. Here's how this file should should look:

```
    export LD_LIBRARY_PATH=~/pmcheck/bin/
```

10. Now you can run RECIPE benchmarks by using 'run.sh' script file. For instance, to run FAST\_FAIR with two threads and 3 keys we use the following command:


```
    ./run.sh ./example 3 2
```

11. Our bug fixes are guarded by 'BUGFIX' flags. To see their impacts on the code, comment each of them in each benchmark, and you can see Jaaru can find an execution that can crash the program without that fix. 

## Disclaimer

We make no warranties that Jaaru is free of errors. Please read the paper and the README file so that you understand what the tool is supposed to do.

## Contact

Please feel free to contact us for more information. Bug reports are welcome, and we are happy to hear from our users. Contact Hamed Gorjiara at [hgorjiar@uci.edu](mailto:hgorjiar@uci.edu), Harry Xu at [harryxu@g.ucla.edu](mailto:harryxu@g.ucla.edu), or Brian Demsky at [bdemsky@uci.edu](mailto:bdemsky@uci.edu) for any questions about Jaaru. 
