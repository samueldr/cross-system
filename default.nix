{ pkgs ? import ./nixpkgs.nix {} }:

let
  nixpkgsPath = pkgs.path;
  fromPkgs = path: pkgs.path + "/${path}";
  evalConfig = import (fromPkgs "nixos/lib/eval-config.nix");
  buildConfig = { system, configuration ? {} }:
    evalConfig {
      specialArgs = {
        inherit nixpkgsPath;
      };
      modules= [
          (./. + "/${system}.nix")
          configuration
      ];
    }
  ;
in
{
  armv6l-linux = {
    sdImage = (buildConfig {
      system = "armv6l-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-raspberrypi.nix");
    }).config.system.build.sdImage;
  };
  armv7l-linux = {
    isoImage = (buildConfig {
      system = "armv7l-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "armv7l-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform-installer.nix");
    }).config.system.build.sdImage;
  };
  aarch64-linux = {
    isoImage = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix");
    }).config.system.build.sdImage;
  };
  helios64 = (buildConfig {
    system = "aarch64-linux";
    configuration = {
      imports = [
        (fromPkgs "nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix")
        ./helios64
      ];
    };
  }).config.system.build.sdImage;
}
