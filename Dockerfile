FROM ubuntu:21.10

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
        python \
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

USER root

ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH
ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man" \
    INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info" \
    HOMEBREW_NO_AUTO_UPDATE=1

RUN chown root /home/linuxbrew/.linuxbrew/bin/brew

# add homebrew end

RUN brew install git fish sqlite3 curl cmake

RUN brew install n && \
      n latest

RUN npm i -g yarn npm && \
      yarn global add node-cmake-generator node-gyp @gengjiawen/node-dev envinfo

# for wasi
ENV PATH=/root/.cargo/bin:$PATH        
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
RUN apt install libssl-dev -y && cargo install --git https://github.com/rustwasm/wasm-pack && rustup target add wasm32-unknown-unknown
        
# setup lldb script for debug v8
RUN node-dev setuplldb

CMD [ "fish" ]
