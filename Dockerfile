FROM ubuntu:20.04 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
            openocd dtc fakeroot perl-bignum json-c-devel verilator \
            python3-devel python3-setuptools libevent-devel \
            libmpc-devel mpfr-devel \
            yosys trellis nextpnr && \
     rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    python3 ./litex_setup.py init install --user && \
    wget http://www.contrib.andrew.cmu.edu/~somlo/BTCP/RISCV-20201216git7553f35.tar.xz && \
    tar xvf RISCV-20201216git7553f35.tar.xz && \
    echo 'export PATH=$PATH:$HOME/RISCV/bin' >> ~/.bashrc && \
    ls
