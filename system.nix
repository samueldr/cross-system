{ system }:
(import <nixpkgs/nixos> { configuration = builtins.toPath (./. + "/${system}.nix"); })
