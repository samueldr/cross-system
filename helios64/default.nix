/*

!!!!!!!!

Bad adaptation of the following:

 - https://github.com/angerman/nixos-docker-sd-image-builder

!!!!!!!!

*/

{ config, pkgs, lib, ... }:

{
  imports = [
    # helios64 specific
    ./modules/fancontrol.nix
    ./modules/heartbeat.nix
    ./modules/ups.nix
    ./modules/usbnet.nix
  ];

  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot.consoleLogLevel = lib.mkDefault 7;

  # Important note about building with the installer profile.
  # XXX the extlinux.conf file needs to be edited manually to remove a bogus entry...
  #     it is unclear why keeping "console=ttyS0,115200n8" doesn't work, even if `ttyS2` is defined after.
  #     causes the serial console to be unusable.
  #     Both are the same "compatible" UART, ttyS0 is ff180000
  boot.kernelParams = lib.mkAfter [
    "console=ttyS2,115200n8"
    "earlyprintk"
    "earlycon=uart8250,mmio32,0xff1a0000"
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_10_helios64;
  # boot.initrd.availableKernelModules = [ "nvme" "pcie-rockchip-host" ];
  # boot.kernelModules = [ "pcie-rockchip-host" ];

  services.sshd.enable = true;
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = true;
}
