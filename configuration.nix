{ config, pkgs, lib, nixpkgsPath, ... }:

{
  imports = [
    (nixpkgsPath + "/nixos/modules/profiles/minimal.nix")
    (nixpkgsPath + "/nixos/modules/profiles/installation-device.nix")
  ];

  nixpkgs.overlays = [(final: super: {
    screen = super.screen.overrideAttrs({ patches ? [], ... }: {
      patches =
        patches ++ [
          # Cross-compilation workaround post GCC 14
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/openwrt/packages/59db1470314a4a3f5c78ad805fa8381de0231936/utils/screen/patches/010-ptyh.patch";
            hash = "sha256-pDlSGKQYGz0lSXzgqFmGLxFf6XnShzI2Vg0VLMy354M=";
          })
        ]
      ;
    });
  })];

  # cifs-utils fails to cross-compile
  # Let's simplify this by removing all unneeded filesystems from the image.
  boot.supportedFilesystems = lib.mkForce [ "vfat" ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
