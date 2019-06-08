{
  imports = [
    ./configuration.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi.nix>
  ];

  nixpkgs.crossSystem = {
    system = "armv6l-linux";
  };
}
