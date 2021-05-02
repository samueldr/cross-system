{
  imports = [
    ./configuration.nix
  ];

  nixpkgs.crossSystem = {
    system = "armv7l-linux";
  };
}
