FROM ubuntu:19.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y \
        build-essential \
        git \
        curl \
        clang \
        clang-format \
        clang-tidy \
        clang-tools \
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

RUN curl -sS https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.sh -o /install_cmake.sh && \
    mkdir /opt/cmake && \
    sh /install_cmake.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

RUN apt-get install -y npm && \
      npm i -g n && \
      npm i -g yarn && \
      n latest && \
      yarn global add node-cmake-generator && \
      npx envinfo

#For clang-tidy
RUN pip3 install pyyaml

CMD [ "fish" ]
