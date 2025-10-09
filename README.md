# Niri FullScreen Manager

It provides [Niri](https://github.com/YaLTeR/niri) with functionality that addresses [this Niri issue](https://github.com/YaLTeR/niri/issues/426).

![demo](./assets/demo.mp4)

## Overview

It all started when I've come across the issue and reported it on the Matrix channel. Then Andrew Song shared a [Python script](https://github.com/YaLTeR/niri/issues/426#issuecomment-3367714198) that works in the common cases, but it breaks in a lot of scenarios. So that was the initial inspiration to try and solve the remaining cases, until I've reached a [massive blocker](https://github.com/YaLTeR/niri/discussions/2554).

When that happened, I ditched a big part of the initial solution and worked on a different approach using Unix sockets to signal when we intend to enter and exit fullscreen. This makes the script much simpler and it's more reliable, but we now need a socket connection for it.

## Usage

Add this flake to your inputs.

```nix
inputs = {
  nfsm-flake = {
    url = "github:gvolpe/nfsm";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Access the exposed packages, e.g.

```nix
inherit (inputs.nfsm-flake.packages.${system}) nfsm nfsm-cli;
```

Only available for Linux systems; run `nix flake show` to see all outputs.

If Nix is not your jam, you can grab the [daemon script](./src/nfsm.py) file directly and give it execution permissions (`chmod +x nfsm.py`). The client script can be found [here](./src/cli.nix).

## Daemon

The `nfsm` daemon can be started in your Niri configuration, e.g.

```kdl
spawn-sh-at-startup "nfsm"
```
 
It will open a Unix Socket under the `/run/user/1000/nfsm.sock` by default (nix-compatible), but it can configured via the `NFSM_SOCKET` environment variable.

## Client

The `nfsm-cli` is a very simple shell script that sends `FullscreenRequest` messages to the daemon via a Unix socket. You could avoid it all together and just do this in your Niri bindings:

```kdl
Mod+Shift+F { spawn-sh "echo 'FullscreenRequest' | socat - UNIX-CONNECT:$NFSM_SOCKET"; }
```

However, the `nfsm-cli` does some error handling and deals with some annoyances, e.g. if it fails to connect to the socket (daemon not running?), it emits a notification and defaults to the standard Niri fullscreen behavior. Without the client, you wouldn't get any feedback on why it isn't working.
