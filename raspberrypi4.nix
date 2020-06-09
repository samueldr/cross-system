{
  imports = [
    ./configuration.nix 
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix>
  ];

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };
}
