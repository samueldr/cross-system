{ pkgs ? import (import ./npins).nixpkgs {} }:

let
  nixpkgsPath = pkgs.path;
  fromPkgs = path: pkgs.path + "/${path}";
  evalConfig = import (fromPkgs "nixos/lib/eval-config.nix");
  buildConfig = { system, variantConfiguration ? {} }:
    evalConfig {
      specialArgs = {
        inherit
          nixpkgsPath
          fromPkgs
        ;
      };
      modules= [
          ./configuration
          (./systems + "/${system}.nix")
          variantConfiguration
          {
            nixpkgs.crossSystem = {
              inherit system;
            };
          }
      ];
    }
  ;
in
{
  armv6l-linux = {
    sdImage = (buildConfig {
      system = "armv6l-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-raspberrypi-installer.nix");
    }).config.system.build.sdImage;
    pkgs = (buildConfig {
      system = "armv7l-linux";
    }).pkgs;
  };
  armv7l-linux = {
    isoImage = (buildConfig {
      system = "armv7l-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "armv7l-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform-installer.nix");
    }).config.system.build.sdImage;
    pkgs = (buildConfig {
      system = "armv7l-linux";
    }).pkgs;
  };
  aarch64-linux = {
    isoImage = (buildConfig {
      system = "aarch64-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "aarch64-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix");
    }).config.system.build.sdImage;
    pkgs = (buildConfig {
      system = "aarch64-linux";
    }).pkgs;
  };
  riscv64-linux = {
    isoImage = (buildConfig {
      system = "riscv64-linux";
      variantConfiguration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "riscv64-linux";
      variantConfiguration = ./systems/riscv64-linux.sd-image.nix;
    }).config.system.build.sdImage;
    pkgs = (buildConfig {
      system = "riscv64-linux";
    }).pkgs;
  };
}
