# Build Docker image for Node.js
[![CircleCI](https://circleci.com/gh/gengjiawen/node-build.svg?style=svg)](https://circleci.com/gh/gengjiawen/node-build)
[![Docker Pulls](https://img.shields.io/docker/pulls/gengjiawen/node-build)](https://hub.docker.com/r/gengjiawen/node-build)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/gengjiawen/node-build/latest?label=latest)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/gengjiawen/node-build/source?label=source)

## Usage
build
```bash
docker run --rm --name build-node -v $PWD:/pwd -w /pwd gengjiawen/node-build bash -c "./configure && make -j4"
```

## What's Included

- Common build/debug tools: git, Git LFS, clang/LLDB, CMake, Node.js with yarn/pnpm, Rust (installed under the `gitpod` user), Chrome, Graphviz, etc.
- Preconfigured `gitpod` user with passwordless sudo to install extra dependencies inside the container.
