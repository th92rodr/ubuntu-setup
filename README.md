# Ubuntu Setup

A shell script to automate the installation and configuration of essential tools, programming languages, and development utilities on a **Debian-based Linux system**.

This script supports any Debian-based distribution (e.g., Ubuntu, Linux Mint, Pop!_OS, MX Linux, Kali Linux, Parrot OS, Debian).

It has been **tested and verified** on:

- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS

> [!NOTE]
> This script is designed for Debian-based distributions. It may not work on Fedora, Arch, or other non-Debian distros without modifications.

---

## 🎯 Features

- OS detection and compatibility checks
- Installs essential tools and dependencies
- Installs and configures programming environments
- Appends shell environment variables (`.bashrc`, `.zshrc`)
- Idempotent: skips installs if already present
- Uses sudo keep-alive to avoid repeated password prompts
- Docker support for isolated testing

---

## 📌 Packages and Programs Installed

### 🔸 System & Utilities
- [curl](https://curl.se/)
- `wget`
- `unzip`
- `make`
- [gcc](https://gcc.gnu.org/)
- `g++`
- `build-essential`
- `tree`
- [fzf](https://github.com/junegunn/fzf)
- [peco](https://github.com/peco/peco)
- [tig](https://github.com/jonas/tig)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- `gnome-tweaks`

### 🔸 Development Tools
- [Git](https://git-scm.com/)
- [Zsh](https://www.zsh.org/)
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Homebrew](https://brew.sh/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Kubernetes (kubectl)](https://kubernetes.io/docs/reference/kubectl/kubectl/)
- [Kubernetes (kubectx)](https://github.com/ahmetb/kubectx)
- [Google Cloud SDK](https://cloud.google.com/sdk)
- [Protocol Buffers (protoc)](https://github.com/protocolbuffers/protobuf)
- [Postman](https://www.postman.com/)

### 🔸 Programming Languages & Runtimes
- Node development environment
  - [Node.js](https://nodejs.org/)
  - [Yarn](https://classic.yarnpkg.com/)
  - [NVM (Node Version Manager)](https://github.com/nvm-sh/nvm)
- [Golang](https://go.dev/)
- [Java JDK](https://openjdk.org/)
- [Pyenv](https://github.com/pyenv/pyenv)

### 🔸 Browsers & Desktop
- [Brave Browser](https://brave.com/)

---

## 🕹️ Usage

### 1. Clone the repository:

```bash
git clone git@github.com:th92rodr/ubuntu-setup.git
cd ubuntu-setup
```

### 2. Grant execute permission to the setup script:

```bash
chmod +x setup.sh
```

### 3. Run the setup script:

```bash
bash setup.sh
```

You’ll be prompted once for your `sudo` password. The script will then handle the rest.

---

## 🐳 Test in Docker

You can test this script in a clean environment, using a docker container, without affecting your system.

### Run directly (run as root)

```bash
docker run -it --name ubuntu-setup-test --rm ubuntu:22.04
```

### Run using a Dockerfile (run as a non-root user)

```bash
docker build --tag ubuntu-setup:1.0 --file Dockerfile .
docker run -it --name ubuntu-setup-test --rm ubuntu-setup:1.0
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE.md).

---

## 🎖️ Give it a star if you like this project!
