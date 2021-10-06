FROM ubuntu:20.04 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
            openocd device-tree-compiler fakeroot libjsoncpp-dev verilator \
            python3-dev python3-setuptools libevent-dev \
            libmpc-dev libmpfr-dev \
            yosys && \
     rm -rf /var/lib/apt/lists/*

WORKDIR /work

RUN git clone --recursive https://github.com/YosysHQ/prjtrellis && \
    cd libtrellis && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make && \
    make install

RUN wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    python3 ./litex_setup.py init install --user && \
    wget http://www.contrib.andrew.cmu.edu/~somlo/BTCP/RISCV-20201216git7553f35.tar.xz && \
    tar xvf RISCV-20201216git7553f35.tar.xz && \
    echo 'export PATH=$PATH:$HOME/RISCV/bin' >> ~/.bashrc && \
    ls
