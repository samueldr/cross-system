{
  imports = [
    ./configuration.nix 
  ];

  nixpkgs.crossSystem = {
    system = "riscv64-linux";
  };
}
