{
  nixpkgs.overlays = [(self: super: {
    # modprobe: FATAL: Module hid_lenovo not found in directory ...
    makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  })];
}
