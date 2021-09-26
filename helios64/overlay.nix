self: super: {
  linux_5_10_helios64 = self.linux_5_10.override {

    kernelPatches = [
      {
        name = "helios64-patch-set.patch";
        patch = ./helios64-patch-set.patch;
      }
    ];

    # Configuration mainly to remove unused platforms and things.
    structuredExtraConfig = with self.lib.kernel; {
      ARCH_ROCKCHIP = yes;

      ARCH_ACTIONS = no;
      ARCH_AGILEX = no;
      ARCH_SUNXI = no;
      ARCH_ALPINE = no;
      ARCH_BCM2835 = no;
      ARCH_BERLIN = no;
      ARCH_BRCMSTB = no;
      ARCH_EXYNOS = no;
      ARCH_K3 = no;
      ARCH_LAYERSCAPE = no;
      ARCH_LG1K = no;
      ARCH_HISI = no;
      ARCH_MEDIATEK = no;
      ARCH_MESON = no;
      ARCH_MVEBU = no;
      ARCH_MXC = no;
      ARCH_QCOM = no;
      ARCH_RENESAS = no;
      ARCH_S32 = no;
      ARCH_SEATTLE = no;
      ARCH_STRATIX10 = no;
      ARCH_SYNQUACER = no;
      ARCH_TEGRA = no;
      ARCH_SPRD = no;
      ARCH_THUNDER = no;
      ARCH_THUNDER2 = no;
      ARCH_UNIPHIER = no;
      ARCH_VEXPRESS = no;
      ARCH_VISCONTI = no;
      ARCH_XGENE = no;
      ARCH_ZX = no;
      ARCH_ZYNQMP = no;
      ARCH_RANDOM = no;
      ARCH_R8A77995 = no;
      ARCH_R8A77990 = no;
      ARCH_R8A77950 = no;
      ARCH_R8A77951 = no;
      ARCH_R8A77965 = no;
      ARCH_R8A77960 = no;
      ARCH_R8A77961 = no;
      ARCH_R8A77980 = no;
      ARCH_R8A77970 = no;
      ARCH_R8A774C0 = no;
      ARCH_R8A774E1 = no;
      ARCH_R8A774A1 = no;
      ARCH_R8A774B1 = no;
      ARCH_STACKWALK = no;

      DRM = no;
      SND = no;
    };
  };

  # Force moduels closure to be built even if some modules are missing
  makeModulesClosure = x:
    super.makeModulesClosure (x // { allowMissing = true; });
}
