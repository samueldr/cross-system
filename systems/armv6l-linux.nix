{ lib, pkgs, ... }:

let
  inherit (lib)
    mkForce
  ;
in
{
  # "raspberrypi" images default to: `pkgs.linuxKernel.packages.linux_rpi1`
  boot.kernelPackages = mkForce pkgs.linuxPackages_latest;

  nixpkgs.overlays = [
    (final: super: {
      # modprobe: FATAL: Module ahci not found in directory /nix/store/scal01jizlpzvpshhda0gpv3a0vwv7kx-linux-armv6l-unknown-linux-gnueabihf-5.10.52-1.20210805-modules/lib/modules/5.10.52
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
