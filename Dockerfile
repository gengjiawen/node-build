FROM ubuntu

RUN apt-get update && \
    apt-get install --yes \
        build-essential \
        curl \
        clang \
        cmake \
        clang-tidy \
        vim \
        python3 \
        python

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
      apt-get install -y nodejs && \
      npm i -g yarn
