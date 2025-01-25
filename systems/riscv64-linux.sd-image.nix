#
# This file implements the missing "generic" "sd card image" for RISC-V.
#
{ config, specialArgs, ... }:

let
  inherit (specialArgs)
    fromPkgs
  ;
in
{
  imports = [
    (fromPkgs "nixos/modules/installer/sd-card/sd-image.nix")
    (fromPkgs "nixos/modules/profiles/base.nix")
    (fromPkgs "nixos/modules/profiles/installation-device.nix")
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible = {
      enable = true;
    };
  };

  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
