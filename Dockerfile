FROM ubuntu:20.04 as builder

# Install deb dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    git cmake build-essential wget meson \
    openocd device-tree-compiler fakeroot libjsoncpp-dev verilator \
    python3-dev python3-setuptools libevent-dev \
    libboost-filesystem-dev libboost-program-options-dev \
    libboost-system-dev libboost-thread-dev \
    libmpc-dev libmpfr-dev \
    yosys && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /work

# Install Project Trellis
# Project Trellis enables a fully open-source flow for ECP5 FPGAs using Yosys for Verilog synthesis and nextpnr for place and route. 
# https://github.com/YosysHQ/prjtrellis
RUN git clone --recursive https://github.com/YosysHQ/prjtrellis && \
    cd prjtrellis/libtrellis && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make && \
    make install

RUN wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    python3 ./litex_setup.py init install --user && \
    wget http://www.contrib.andrew.cmu.edu/~somlo/BTCP/RISCV-20201216git7553f35.tar.xz && \
    tar xvf RISCV-20201216git7553f35.tar.xz && \
    echo 'export PATH=$PATH:/work/RISCV/bin' >> ~/.bashrc && \
    echo 'ls of current workdir:' && \ 
    ls && \
    echo 'all done'

ENV PATH=$PATH:/work/RISCV/bin

RUN litex-boards/litex_boards/targets/lattice_versa_ecp5.py --build \
    --cpu-type rocket --cpu-variant linuxd --sys-clk-freq 50e6
