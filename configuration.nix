{ config, pkgs, lib, ... }:

let
  system = "aarch64-linux";
  #system = "armv7l-linux";
  #system = "armv6l-linux";
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
  ]
  ++ lib.optional (system == "aarch64-linux") <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
  ++ lib.optional (system == "armv7l-linux")  <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-armv7l-multiplatform.nix>
  ++ lib.optional (system == "armv6l-linux")  <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi.nix>
  ;

  nixpkgs.crossSystem = {
    inherit system;
  };

  nixpkgs.overlays = [(self: super: {
    # Does not cross-compile...
    alsa-firmware = pkgs.runCommandNoCC "neutered-firmware" {} "mkdir -p $out";
  })];

  # (Failing build in a dep to be investigated)
  security.polkit.enable = false;

  # cifs-utils fails to cross-compile
  # Let's simplify this by removing all unneeded filesystems from the image.
  boot.supportedFilesystems = lib.mkForce [ "vfat" ];

  # texinfoInteractive has trouble cross-compiling
  documentation.info.enable = lib.mkForce false;

  # Somehow, `xterm` is being built even though this is GUI-less?
  #  → https://github.com/NixOS/nixpkgs/blob/100f0b032dcb07ff5e1b9e29ed3975b43ce12242/nixos/modules/services/x11/desktop-managers/xterm.nix#L16
  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
}
