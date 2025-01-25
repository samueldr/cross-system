{
  nixpkgs.overlays = [(self: super: {
    # Works around libselinux failure with python on armv7l.
    # LONG_BIT definition appears wrong for platform
    libselinux = (super.libselinux
      .override({
        enablePython = false;
      }))
      .overrideAttrs (_: {
        preInstall = ":";
      })
    ;
  })];
}
