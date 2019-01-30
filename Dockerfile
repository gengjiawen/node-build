FROM ubuntu

RUN apt-get update && \
    apt-get install --yes \
        build-essential \
        git \
        curl \
        cmake \
        clang \
        clang-tidy \
        clang-tools \
        vim \
        python3 \
        python3-pip \
        python

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
      apt-get install -y nodejs && \
      npm i -g yarn

RUN pip3 install pyyaml
