#!/bin/sh

# This script is intended to run from a Linux (including WSL) environment with
# Docker installed.
#
# It creates a Docker container to cross-compile the iperf3 executable for NISOM
# target hardware
#
# It assumes that you've installed the cross-compiler install shell script at
# ./resources/NISOM/oecore-x86_64-armv7a-vfp-neon-toolchain-2.0.sh

# Create the docker container
docker build -f Dockerfile.nisom_iperf_builder -t iperf_builder .

# Run the container to build iperf3
docker run -it --name iperf_builder --mount type=bind,source=..,destination=/home/iperf/ -w /home/iperf iperf_builder

echo "If build was successful, executable will be at ../src/iperf3"

# Delete the container
docker rm iperf_builder