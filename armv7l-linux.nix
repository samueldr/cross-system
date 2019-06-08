{
  imports = [
    ./configuration.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-armv7l-multiplatform.nix>
  ];

  nixpkgs.crossSystem = {
    system = "armv7l-linux";
  };
}
