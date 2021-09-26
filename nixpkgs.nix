let
  revision = "bc9b956714ed6eac5f8888322aac5bc41389defa";
in
import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz";
  sha256 = "1wbd66h3hszlmdh0mpj0a51jk580aq2xal30wc0lgk78s6sf0rw7";
})
