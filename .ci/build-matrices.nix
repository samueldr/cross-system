{ filter ? "", system ? builtins.currentSystem }:

let
  release = (import ../release.nix {});

  filtered =
    builtins.filter
    (name: builtins.match ".*${filter}.*" name == [])
    (builtins.attrNames release)
  ;
  matrix = {
    include =
      builtins.map (
        attr: { inherit attr; }
      ) filtered
    ;
  };
in
# NOTE: This derivation is an exercise in futility.
# It makes a proper derivation so `nix-build` can be used to get the evaluation output as JSON.
# This is to (needlessly) rely solely on the `nix-build` action intrinsics to build the matrix.
derivation {
  name = "matrix.json";
  matrixPath = builtins.toFile "matrix.json" (builtins.toJSON matrix);
  builder = "/bin/sh";
  # See: https://github.com/samueldr/cat
  args = [ "-c" ''
    #!/bin/sh
    # SPDX-License-Identifier: CC0 OR BSD-3-Clause

    #
    # A good enough approximation of `cat` for busybox sh.
    # ====================================================
    #
    # Author: Samuel Dionne-Riel <samuel@dionne-riel.com>
    # License: CC0, Public Domain, or BSD-3-Clause.
    #
    #   - CC0-1.0: https://spdx.org/licenses/CC0-1.0.html
    #   - BSD-3-Clause: https://spdx.org/licenses/BSD-3-Clause.html
    #
    # Please be kind and keep this header and attribution, if possible.
    #

    # Where we're going, we don't need system commands.
    unset PATH

    # Ensure those are not going to cause issues
    unset LANG
    unset LC_ALL
    unset LC_CTYPE
    unset LC_MESSAGES
    unset LC_NUMERIC
    unset NLSPATH

    # Handles shuffling bytes around from stdin to stdout
    _cat_pipe() {
        (
            # No field splitting, or any similar behaviour, desired
            #    - https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html#tag_19_05_03
            IFS=""
            # shellcheck disable=SC3045
            while read -n 1 -d "" -r "char"; do
                if test "$char" = ""; then
                    printf "\x00"
                else
                    printf "%c" "$char"
                fi
            done
        )
    }
    # Handles parameters to this command
    _cat() {
        if test "$#" -lt 1; then
            _cat_pipe
        else
            for arg in "$@"; do
                <"$arg" _cat_pipe
            done
        fi
    }

    _cat_pipe < "$matrixPath" > "$out"
  ''];
  inherit system;
}
