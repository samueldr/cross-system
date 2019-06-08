{
  imports = [
    ./configuration.nix 
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
  ];

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };
}
