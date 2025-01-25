{ config, pkgs, lib, nixpkgsPath, ... }:

{
  imports = [
    (nixpkgsPath + "/nixos/modules/profiles/minimal.nix")
    (nixpkgsPath + "/nixos/modules/profiles/installation-device.nix")
  ];

  nixpkgs.overlays = [(final: super: {
    screen = super.screen.overrideAttrs({ patches ? [], ... }: {
      patches =
        patches ++ [
          # Cross-compilation workaround post GCC 14
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/openwrt/packages/59db1470314a4a3f5c78ad805fa8381de0231936/utils/screen/patches/010-ptyh.patch";
            hash = "sha256-pDlSGKQYGz0lSXzgqFmGLxFf6XnShzI2Vg0VLMy354M=";
          })
        ]
      ;
    });

    #
    # armv7l and armv6l:
    #
    # ```
    #   396 |                 iter->esl = (efi_signature_list_t *)((intptr_t)iter->buf
    #       |                             ^
    # esl-iter.c:414:74: error: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'off_t' {aka 'long long int'} [-Werror=format=]
    #   414 |                         warnx("correcting ESL size from %d to %jd at 0x%lx",
    #       |                                                                        ~~^
    #       |                                                                          |
    #       |                                                                          long unsigned int
    #       |                                                                        %llx
    #   415 |                               iter->esl->signature_list_size,
    #   416 |                               (intmax_t)(iter->len - iter->offset), iter->offset);
    #       |                                                                     ~~~~~~~~~~~~
    #       |                                                                         |
    #       |                                                                         off_t {aka long long int}
    # cc1: all warnings being treated as errors
    # make[1]: *** [/build/source/src/include/rules.mk:53: esl-iter.o] Error 1
    # make[1]: Leaving directory '/build/source/src'
    # make: *** [Makefile:17: all] Error 2
    # ```
    efivar = super.efivar.overrideAttrs({ env ? {}, ... }: {
      env.NIX_CFLAGS_COMPILE = "${env.NIX_CFLAGS_COMPILE or ""} -Wno-error=format -Wno-error=int-to-pointer-cast";
    });
  })];

  # cifs-utils fails to cross-compile
  # Let's simplify this by removing all unneeded filesystems from the image.
  boot.supportedFilesystems = lib.mkForce [ "vfat" ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
