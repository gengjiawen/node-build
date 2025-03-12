FROM ubuntu:24.10

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=clang
ENV CXX=clang++

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt update && \
    apt install -y \
        build-essential \
        software-properties-common \ 
        git \
        curl \
        wget \
        ssh \
        tar \
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
        locales \
        locales-all \
        python3 \
        python3-pip \
        python-is-python3 \
        libssl-dev \
        iproute2 \
        psmisc \
        graphviz \
        p7zip-full \
        doxygen \
        sudo \
        r-base \
        time \
        vim

# add homebrew
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

USER gitpod

RUN mkdir -p ~/.cache && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH
ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man" \
    INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info" \
    HOMEBREW_NO_AUTO_UPDATE=1

# add homebrew end

RUN brew install git fish sqlite3 curl cmake n

USER root
ENV PATH=/usr/lib/ccache:$PATH
RUN n latest
RUN pip3 install scons --break-system-packages

RUN echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH' >> ~/.bashrc
RUN echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH' >> /home/gitpod/.bashrc

RUN npm i -g yarn pnpm npm npm-check-updates && \
      yarn global add node-cmake-generator node-gyp @gengjiawen/node-dev envinfo
        
# setup lldb script for debug v8
RUN node-dev setuplldb

RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install -y google-chrome-stable --no-install-recommends \
  && apt-get install -y fonts-noto fonts-noto-cjk 

RUN apt install ffmpeg -y

# for WASI
# RUN brew install rustup 
ENV PATH=/root/.cargo/bin:$PATH        
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN cargo install --git https://github.com/rustwasm/wasm-pack && rustup target add wasm32-unknown-unknown && cargo install cargo-workspaces
RUN envinfo
