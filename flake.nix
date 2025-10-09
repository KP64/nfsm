{
  description = "Niri FullScreen Manager (NFSM)";

  inputs = {
    # nix doesn't need the full history, this should be the default ¯\_(ツ)_/¯
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    systems.url = github:nix-systems/default-linux;
    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.systems.follows = "systems";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        nfsm-overlay = f: p: {
          nfsm = p.callPackage ./src/drv.nix { };
          nfsm-cli = p.callPackage ./src/cli.nix { };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nfsm-overlay ];
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          inherit (pkgs) nfsm nfsm-cli;
          default = pkgs.nfsm;
        };
      }
    );
}
