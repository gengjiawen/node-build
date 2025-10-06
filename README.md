# Build Docker image for Node.js
[![CircleCI](https://circleci.com/gh/gengjiawen/node-build.svg?style=svg)](https://circleci.com/gh/gengjiawen/node-build)
[![Docker Pulls](https://img.shields.io/docker/pulls/gengjiawen/node-build)](https://hub.docker.com/r/gengjiawen/node-build)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/gengjiawen/node-build/latest?label=latest)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/gengjiawen/node-build/source?label=source)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/gengjiawen/node-build/chrome?label=chrome)

## Usage
build
```bash
docker run --rm --name build-node -v $PWD:/pwd -w /pwd gengjiawen/node-build bash -c "./configure && make -j4"
```

remote debug in CLion
```bash
docker run -d --cap-add sys_ptrace -p2222:22 --name clion_remote_env gengjiawen/node-build:remote
```

## Remote Development

This base image is ready for local and remote development. It includes:

- Common build/debug tools: git, Git LFS, clang/LLDB, CMake, Node.js with yarn/pnpm, Rust (installed under the `gitpod` user), Chrome, Graphviz, etc.
- Preconfigured `gitpod` user with passwordless sudo to install extra dependencies inside the container.
- A `:remote` variant for IDE remote development over SSH.

VS Code (Remote-SSH)

```bash
# Run the remote image with SSHD and map port 22
docker run -d --cap-add sys_ptrace -p 2222:22 \
  --name vscode_remote_env gengjiawen/node-build:remote
```

Security: change the root password immediately

```bash
docker exec -it vscode_remote_env passwd
# or via SSH then run passwd
ssh root@localhost -p 2222
passwd
```

Steps in VS Code:
- Install the "Remote - SSH" extension
- Command Palette → "Remote-SSH: Connect to Host..." → node-build-remote
- When prompted, enter password

Tip: You can also connect directly via root@localhost:2222 without an SSH config.

JetBrains Gateway / CLion (SSH)

```bash
# Run the remote image with SSHD and map port 22
docker run -d --cap-add sys_ptrace -p 2222:22 \
  --name jetbrains_remote_env gengjiawen/node-build:remote
```

Security: change the root password immediately

```bash
docker exec -it jetbrains_remote_env passwd
```

Note: The `:remote` image is intended for local or trusted environments only. It enables password login for root by default. Change the root password immediately and do not expose it directly to the public internet.
