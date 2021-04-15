# Build Docker image for Node.js
[![CircleCI](https://circleci.com/gh/gengjiawen/node-build.svg?style=svg)](https://circleci.com/gh/gengjiawen/node-build)
[![Docker Pulls](https://img.shields.io/docker/pulls/gengjiawen/node-build)](https://hub.docker.com/r/gengjiawen/node-build)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/gengjiawen/node-build)

## Usage
build
```bash
docker run --rm --name build-node -v $PWD:/pwd -w /pwd gengjiawen/node-build bash -c "./configure && make -j4"
```

remote debug in CLion
```bash
docker run -d --cap-add sys_ptrace -p2222:22 --name clion_remote_env gengjiawen/node-build:remote
```
