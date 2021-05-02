{
  imports = [
    ./configuration.nix 
  ];

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };
}
