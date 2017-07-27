Original [README](https://github.com/rchain/Rosette/blob/master/README).

## Dockerized 32-bit Rosette

### TL;DR
Three easy steps:
```
git clone git@github.com:kirkwood/rosette --branch docker-build
```
```
docker build . -t rosette-repl:latest
```
```
docker run -ti rosette-repl
```

### Preliminaries

I selected the 32-bit Ubuntu 14.04 image, since it's not _too_ old and it's not _too_ new. Arbitrary choice, really.

Building requires a working docker situation, but I've only tested with this version:
```
$ docker version
Client:
 Version:      17.05.0-ce
 API version:  1.29
 Go version:   go1.7.5
 Git commit:   89658be
 Built:        Thu May  4 22:15:36 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.05.0-ce
 API version:  1.29 (minimum version 1.12)
 Go version:   go1.7.5
 Git commit:   89658be
 Built:        Thu May  4 22:15:36 2017
 OS/Arch:      linux/amd64
 Experimental: false
```

If you haven't got docker, it's in the Linux repositories, and I _know_ there's a Mac OS X flavor that works for many things. I can't help you with that, though.

### Building

This is the `master` branch of the main line with a few compiler warnings muffled and a few Linux-specific `#define` additions. I did not include fixes for missing constness and other bitrot. The Dockerfile is set to build only the initial VM image and doesn't try to load the full environment until it is run. I couldn't see a way to dump a loaded-up image from Rosette anyway. 

To build, issue
```
docker build . -t rosette-repl:latest
```
and you should see lots and lots of output, something like
```
Sending build context to Docker daemon  4.772MB
Step 1/7 : FROM ioft/i386-ubuntu:14.04
 ---> 301e78ffa569
Step 2/7 : RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y g++ make
 ---> Using cache
 ---> 87a312f95278
Step 3/7 : COPY . /src/
 ---> 04dbfd3e08e4
Removing intermediate container 1d5f8ff76d63
Step 4/7 : WORKDIR /src
 ---> 6b54e706838c
Removing intermediate container 6a85bc95fb9a
Step 5/7 : RUN make -C src
 ---> Running in 9b720cfac491
make: Entering directory `/src/src'
g++  -I ../h -I ../h/sys -DARCH_INC=\"linux.h\" -Wno-write-strings -Wno-invalid-offsetof  -c -o Actor.o Actor.cc
g++  -I ../h -I ../h/sys -DARCH_INC=\"linux.h\" -Wno-write-strings -Wno-invalid-offsetof  -c -o RblAtom.o RblAtom.cc
In file included from RblAtom.cc:30:0:
../h/RblAtom.h:111:12: warning: deprecated covariant return type for 'virtual char* Char::asCstring()' [enabled by default]
     char*  asCstring ();

[ . . . LOTS OF COMPILER WARNINGS . . . ]

 ---> f73810aaeca6
Removing intermediate container b64580c6d50c
Successfully built f73810aaeca6
Successfully tagged rosette-repl:latest
```
The final line is the important one.

### Running
Invoking the REPL should be as simple as
```
docker run -ti rosette-repl
```
which will fill out the initial environment:
```
make: Entering directory `/src/rbl'
cd rosette; make
make[1]: Entering directory `/src/rbl/rosette'
../../bin/boot-ess -boot boot.rbl
Rosette System, Version 3.0 (Jan 20, 1993 02:00:32 PM) - Copyright 1989, 1990, 1991, 1992 MCC
loading: ./configuration.rbl silent
loading: ./sbo-init.rbl silent
loading: ./system.rbl silent
loading: ./expander.rbl silent
loading: ./multimethod.rbl silent
loading: ./document.rbl silent
loading: ./config.rbl silent
loading: ./meth-proc-oprns.rbl silent
loading: ./que-stk-oprns.rbl silent
loading: ./string-oprns.rbl silent
loading: ./tuple-oprns.rbl silent
loading: ./table-oprns.rbl silent
loading: ./io-system.rbl silent
loading: ./exceptions.rbl silent
loading: ./time.rbl silent
loading: ./trace.rbl silent
loading: ./classes-types.rbl silent
loading: ./c-structures.rbl silent
loading: ./foreign-funs.rbl silent
loading: ./async-repl.rbl silent
loading: ./dyn-load.rbl silent
loading: ./apropos.rbl silent
rosette> (+ 1 2)
3
rosette> 'yay! 
'yay!
```
and present you with that prompt.
