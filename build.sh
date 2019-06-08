#!/usr/bin/env bash

set -e
set -u
PS4=" $ "

export NIX_PATH="nixpkgs=$PWD/../nixpkgs"

set -x
exec env -i NIX_PATH="$NIX_PATH" nix-build \
  system.nix -A config.system.build.sdImage "$@"
