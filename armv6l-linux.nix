{
  imports = [
    ./configuration.nix
  ];

  nixpkgs.crossSystem = {
    system = "armv6l-linux";
  };
}
