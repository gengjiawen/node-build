FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=clang
ENV CXX=clang++

RUN apt update && \
    apt install -y \
        build-essential \
        software-properties-common \ 
        git \
        curl \
        wget \
        rsync \
        ccache \
        clang \
        clangd \
        clang-format \
        clang-tidy \
        clang-tools \
        lldb \
        gdb \
        ninja-build \
        python3 \
        python3-pip \
        python \
        graphviz \
        p7zip-full \
        doxygen \
        sudo \
        r-base \
        time \
        vim
        
# for wasi
ENV PATH=/root/.cargo/bin:$PATH        
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
RUN cargo install --git https://github.com/rustwasm/wasm-pack && rustup target add wasm32-unknown-unknown
        
RUN apt-add-repository ppa:fish-shell/release-3 && apt update && apt install fish -y

#For clang-tidy and cmake
RUN python3 -m pip install -U pip && pip3 install pyyaml && pip3 install cmake

RUN apt-get install -y npm && \
      npm i -g n && \
      n latest

RUN npm i -g yarn && \
      yarn global add node-cmake-generator node-gyp @gengjiawen/node-dev envinfo

# setup lldb script for debug v8
RUN node-dev setuplldb

CMD [ "fish" ]
