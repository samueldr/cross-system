{
  nixpkgs.overlays = [(final: super: {
    grub2 = super.grub2.overrideAttrs({ patches ? [], ... }: {
      patches = patches ++ [
        # grub-mkimage: error: relocation 0x2b is not implemented yet.
        # https://savannah.gnu.org/bugs/?65909
        # https://lists.gnu.org/archive/html/bug-grub/2024-06/msg00012.html
        # (Alternatively, gcc13Stdenv could be used.)
        (super.fetchpatch {
          url = "https://file.savannah.gnu.org/file/0263-Use-medany-instead-of-large-model-for-RISCV.patch?file_id=56184";
          hash = "sha256-s6uPdM6vug+7lZ1FPhup+P4uFRO02+YtbVxDUDn1WLc=";
        })
      ];
    });
  })];
}
