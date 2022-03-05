let
  revision = "d5f237872975e6fb6f76eef1368b5634ffcd266f";
in
import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz";
  sha256 = "0fsjwhqgxyd2v86glr2560gr3zx9mb6fhllydmrxi5i04c549vsr";
})
