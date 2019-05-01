# Build Docker image for nodejs
[![CircleCI](https://circleci.com/gh/gengjiawen/node-build.svg?style=svg)](https://circleci.com/gh/gengjiawen/node-build)
## Usage
build
```bash
docker run --rm --name build-node -v $PWD:/pwd -w /pwd gengjiawen/node-build bash -c "./configure && make -j4"
```
