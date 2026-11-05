<div align="center">

# herdr-core

> Fork of [dariogriffo/herdr-core-debian](https://github.com/dariogriffo/herdr-core-debian) (MIT); the original packaging is by Dario Griffo. Served at [deb.gaofn.xyz](https://deb.gaofn.xyz) for Debian 12 (bookworm) and 13 (trixie).

**Terminals for coding agents that stay alive.**

![GitHub License](https://img.shields.io/github/license/herdrdev/herdr-core)

</div>

## About

herdr-core runs programs and coding agents in terminals that keep running
when the window, SSH session or login that started them goes away. You drive
it from the command line (`herdr-core run`, `ls`, `read`, `attach`, `send`,
`wait`, ...) or through its JSON-RPC API, on this machine or on others you
reach over SSH (`herdr-core machine add`).

It is the core that the Herdr desktop app (`herdr-app`) runs its terminals in.

**The command is `herdr-core`.** Upstream calls it `hc`, but this package does
not install that alias: Debian's `httpcode` package already ships
`/usr/bin/hc`. Add `alias hc=herdr-core` to your shell if you want it.

Under systemd the core runs as a user service, so it outlives your logins.
Without systemd it ends with whatever started it.

Updates come through apt. `herdr-core update` (and Herdr's "update
herdr-core" button) cannot replace `/usr/bin/herdr-core`, so use
`sudo apt upgrade` instead.

**[Read the documentation](https://github.com/herdrdev/herdr-core)**
