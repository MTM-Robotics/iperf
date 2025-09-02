# Airbus Robotics: iPerf3 for NISOM
This folder provides scripts and utilities to build and run the open-source _iPerf3_
application for National Instruments SOM boards used as controllers in Airbus Robotics systems. 
The utility provides Ethernet network throughput debugging and stress-testing.

The _iPerf3_ application is built as a non-dynamic application with very light dependencies for 
easy installation on the NISOM target running the Airbus Robotics standard Linux distribution for
these robotic controllers.

# Building
To build the application from source:
1. Ensure that the proper cross-compiler install script has been copied to the local
*./resources/NISOM/oecore-x86_64-armv7a-vfp-neon-toolchain-2.0.sh*
(This script contains very large binary components, so it is not included in this source code repository. Find it in Airbus Robotics share drive at
*X:\Engineering\Software\Cross Compilers\NISOM_Linux_Host*)
1. Run the build shell script, which builds and launches a docker container to execute the cross-compilation:
```
$ ./build_nisom_iperf3.sh
```

Following successful build, the application is at
*../src/iperf3.sh*

To install the app to target hardware, simply copy it (SCP, etc.) to the target board's filesystem (any location is fine, but a standard place like
*/home/admin/iperf3* is recommended).

**Note: If the NISOM Linux distro is ever updated to one of the later National Instruments-provided versions, the Dockerfile should be updated to call
out the new proper cross-compile installer.**

**During initial testing of the build, some compiler errors were encountered due to multiple definitions of the same symbols where _iPerf3_ source code 
includes both system and userspace versions of some of the network-specific header files. The work-around is that this repository includes versions 
of those header files that have the offending symbol definitions commented out, and these headers are copied over the existing headers in the cross 
tool chain after it is installed and before it is used in the build. If the cross tool chain is ever updated (consistent with the previous note), 
these header file overrides should be re-examined... they may no longer be necessary in that case.**

# Running
The application requires two network endpoints be running _iPerf3_ with compatible settings. Commonly a non-embedded system (Windows or Linux host)
serves as one of these endpoints. For that system, _iPerf3_ can be installed from the downloadable binaries provided by the maintainers:
https://iperf.fr/iperf-download.php
(or built from source easily using the instructions in the parent directory README).

One endpoint acts as the server and one as the client. In practice it doesn't matter much which is which, though for complete testing it can be
useful to run tests with each endpoint serving in each role.

The _iPerf3_ application has many command-line options and for advanced testing it is recommended that you familiarize yourself with these and choose
test(s) that best represent the scenario(s) you wish to cover. Below we provide example usage for standard UDP max-throughput stress-testing, which
is a good general-purpose test scenario.

See _iPerf3_ user documentation for complete usage:
https://iperf.fr/iperf-doc.php

## Example -- UDP Stress Testing
The following sets up a UDP network stress test between a Windows host acting as server and a NISOM host acting as client. A large bandwidth (100 Mbps)
is specified and 4 parallel connections are made from client to server to ensure as much traffic on the network as possible. IPv4 is used exclusively.

Windows_Host@192.168.0.100 (start this first):
```
> iperf3 -s -B 192.168.0.100
```

NISOM_Host@192.168.0.10 (start this second):
```
$ ./iperf3 -c 192.168.0.100 -u -b 100M -P 4 -4
```

This test will run for 10 seconds and print throughput and packet loss statistics at the end.

## Additional Examples
See online documentation for additional examples. Here's a good place to start:
https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/iperf/


