let
  revision = "9370544d849be8a07193e7611d02e6f6f1b10768";
in
import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz";
  sha256 = "0g61bfs8q5y3z73ms2gf8hlaxifr77rmqbfi0xbbp9lv61pz0ijd";
})
