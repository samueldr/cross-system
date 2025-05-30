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

      # Mainline U-Boot may have broken build for armv6l U-Boot
      ubootRaspberryPi = super.ubootRaspberryPi.override {
        extraConfig = ''
           # CONFIG_EFI_LOADER is not set
        '';
      };
      ubootRaspberryPiZero = super.ubootRaspberryPiZero.override {
        extraConfig = ''
           # CONFIG_EFI_LOADER is not set
        '';
      };
    })
  ];
}
