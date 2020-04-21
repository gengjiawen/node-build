FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=clang
ENV CXX=clang++

RUN apt update && \
    apt install -y \
        build-essential \
        git \
        curl \
        wget \
        rsync \
        clang \
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
        r-base \
        fish \
        time \
        vim

#For clang-tidy and cmake
RUN python3 -m pip install -U pip && pip3 install pyyaml && pip3 install cmake

RUN apt-get install -y npm && \
      npm i -g n && \
      npm i -g yarn && \
      n latest && \
      yarn global add node-cmake-generator node-gyp @gengjiawen/node-dev && \
      npx envinfo

# setup lldb script for debug v8
RUN node-dev setuplldb

CMD [ "fish" ]
