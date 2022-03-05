{
  imports = [
    ./configuration.nix
  ];

  nixpkgs.crossSystem = {
    system = "armv6l-linux";
  };

  nixpkgs.overlays = [
    (final: super: {
      # modprobe: FATAL: Module ahci not found in directory /nix/store/scal01jizlpzvpshhda0gpv3a0vwv7kx-linux-armv6l-unknown-linux-gnueabihf-5.10.52-1.20210805-modules/lib/modules/5.10.52
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
