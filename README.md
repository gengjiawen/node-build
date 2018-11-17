# Build Docker image for nodejs
## Usage
build
```bash
docker run --rm --name build-node -v $PWD:/pwd -w /pwd gengjiawen/node-build bash -c "./configure && make -j4"
```
