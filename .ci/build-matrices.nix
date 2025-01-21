{ filter ? "" }:

let
  release = (import ../release.nix {});

  filtered =
    builtins.filter
    (name: builtins.match ".*${filter}.*" name == [])
    (builtins.attrNames release)
  ;
in
{
  include =
    builtins.map (
      attr: { inherit attr; }
    ) filtered
  ;
}
