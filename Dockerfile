FROM ubuntu:25.04

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
        git-lfs \
        curl \
        ca-certificates \
        wget \
        gnupg \
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
        iputils-ping \
        traceroute \
        psmisc \
        graphviz \
        doxygen \
        sudo \
        r-base \
        time \
        ffmpeg \
        vim \
        default-jdk

# Configure Git LFS at the system level before switching users
RUN git lfs install --system

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

RUN brew install git fish n sqlite3 curl cmake go sevenzip ripgrep

USER root
ENV PATH=/usr/lib/ccache:$PATH
RUN n latest && npm i -g n yarn pnpm npm
RUN ln -sfn "$(which 7zz)" /usr/local/bin/7z

# install google chrome
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install -y google-chrome-stable --no-install-recommends \
  && apt-get install -y fonts-noto fonts-noto-cjk

RUN pip3 install scons --break-system-packages

USER gitpod
ENV PNPM_HOME=/home/gitpod/.pnpm
ENV PATH="${PATH}:${PNPM_HOME}"
RUN pnpm i -g node-cmake-generator node-gyp @gengjiawen/node-dev envinfo npm-check-updates @openai/codex @anthropic-ai/claude-code fkill-cli

# setup lldb script for debug v8
RUN node-dev setuplldb

USER gitpod
ENV RUSTUP_HOME=/home/gitpod/.rustup
ENV CARGO_HOME=/home/gitpod/.cargo
ENV PATH=$CARGO_HOME/bin:$PATH

RUN mkdir -p "$CARGO_HOME" "$RUSTUP_HOME" \
  && curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable -c rust-analyzer -c rust-src -c rustfmt -c clippy

RUN cargo install --git https://github.com/rustwasm/wasm-pack && rustup target add wasm32-unknown-unknown && cargo install cargo-workspaces cargo-insta

USER root
RUN echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:/home/gitpod/.pnpm:/home/gitpod/.cargo/bin:$PATH' >> /home/gitpod/.bashrc
RUN bash -lc "echo -e 'export RUSTUP_HOME=/home/gitpod/.rustup\nexport CARGO_HOME=/home/gitpod/.cargo\nexport PNPM_HOME=/home/gitpod/.pnpm' >> /home/gitpod/.bashrc"
RUN echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:/home/gitpod/.pnpm:/home/gitpod/.cargo/bin:$PATH' >> /root/.bashrc
RUN bash -lc "echo -e 'export RUSTUP_HOME=/home/gitpod/.rustup\nexport CARGO_HOME=/home/gitpod/.cargo\nexport PNPM_HOME=/home/gitpod/.pnpm' >> /root/.bashrc"
