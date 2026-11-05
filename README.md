![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/gaofengnan/herdr-core-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/gaofengnan/herdr-core-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/gaofengnan/herdr-core-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/gaofengnan/herdr-core-debian)

<h1>
   <p align="center">
     <a href="https://herdr.dev"><img src="https://github.com/gaofengnan/herdr-core-debian/blob/main/herdr-core.svg" alt="Herdr Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/gaofengnan/herdr-core-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>herdr-core for Debian
   </p>
</h1>
<p align="center">
 Terminals for coding agents that stay alive.
</p>

# herdr-core for Debian

> Fork of [dariogriffo/herdr-core-debian](https://github.com/dariogriffo/herdr-core-debian) (MIT); the original packaging is by Dario Griffo. Served at [deb.gaofn.xyz](https://deb.gaofn.xyz) for Debian 12 (bookworm) and 13 (trixie).

This repository contains build scripts to produce the _unofficial_ Debian and
Ubuntu packages (.deb) for [herdr-core](https://github.com/herdrdev/herdr-core/)
hosted at [deb.gaofn.xyz](https://deb.gaofn.xyz)

herdr-core runs programs and coding agents in terminals that stay alive after
the window, SSH session or login that started them goes away. It is the core
the Herdr desktop app ([herdr-app](https://github.com/dariogriffo/herdr-app-debian))
runs its terminals in, and `herdr-app` depends on this package.

**The package and the command are both called `herdr-core`.** Upstream also
installs a short `hc` alias, but Debian and Ubuntu's `httpcode` package
already ships `/usr/bin/hc`, so this package does not. Add
`alias hc=herdr-core` to your shell if you want it. Herdr finds the core by
either name.

Currently supported distros are:
- Debian Bookworm (v12), Trixie (v13), Forky (v14), Sid
- Ubuntu Jammy (22.04), Noble (24.04), Questing (25.10), Resolute (26.04)

Supported architectures:
- amd64 (x86_64) - All distributions
- arm64 (aarch64) - All distributions

Upstream ships a static binary for each architecture, so it runs on every suite
above. Upstream only publishes Linux builds for these two architectures, so
there are no i386, armhf, armel or riscv64 packages.

One package per architecture is built and shared by every suite
(`herdr-core_<version>-<build>~griffo_<arch>.deb`). It repackages upstream's
own Linux build from [releases.herdr.dev](https://releases.herdr.dev) (the
GitHub repository has tags but no release assets): `/usr/bin/herdr-core` and
the license. `openssh-client` is a dependency (`ssh` and `scp` reach other
machines). `systemd` is recommended: with it the core runs as a systemd user
service and outlives your logins; without it, it ends with whatever started
it.

Updates come through apt. `herdr-core update` and Herdr's "update herdr-core"
button try to replace the binary in place and cannot write to
`/usr/bin/herdr-core`; run `sudo apt upgrade` instead.

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the herdr-core source code, see
[herdr-core](https://github.com/herdrdev/herdr-core/).

## Install/Update

### The Debian way

```sh
sudo install -d -m 0755 /etc/apt/keyrings
sudo curl -fsSL https://deb.gaofn.xyz/deb.gaofn.xyz.gpg -o /etc/apt/keyrings/deb.gaofn.xyz.gpg
sudo curl -fsSL https://deb.gaofn.xyz/deb.gaofn.xyz.sources -o /etc/apt/sources.list.d/deb.gaofn.xyz.sources
# Debian 12 (bookworm): fetch deb.gaofn.xyz-bookworm.sources instead
sudo apt update
sudo apt install -y herdr-core
```

### Manual Installation

1. Download the .deb package for your architecture from
   the [Releases](https://github.com/gaofengnan/herdr-core-debian/releases) page.
2. Install it with apt, so the dependencies are pulled in.

```sh
sudo apt install ./<filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <herdr_core_version> <build_version> <architecture>
# Example: ./build.sh 0.1.14 1 arm64
```

### Build for all architectures
```sh
./build.sh <herdr_core_version> <build_version> all
# Example: ./build.sh 0.1.14 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to herdr-core. This repo is only for _unofficial_ Debian packaging.
