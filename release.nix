{ pkgs ? import (import ./npins).nixpkgs {} }:
let
  default = import ./default.nix { inherit pkgs; };

  renamed =
    builtins.listToAttrs (
      builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            system: images:
            builtins.map (
              name:
              {
                name = "${system}/${name}";
                value = images.${name};
              }
            ) (builtins.filter (attr: attr != "pkgs") (builtins.attrNames images))
          ) default
        )
      )
    )
  ;
in
renamed
