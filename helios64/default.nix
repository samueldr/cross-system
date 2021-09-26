/*

!!!!!!!!

Bad adaptation of the following:

 - https://github.com/angerman/nixos-docker-sd-image-builder

!!!!!!!!

*/

{ config, pkgs, lib, ... }:
{
  imports = [
    # helios64 specific
    #./modules/ups.nix
    #./modules/heartbeat.nix
    ./modules/fancontrol.nix
    ./modules/usbnet.nix
  ];

  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  #boot.loader.grub.enable = false;
  #boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  boot.kernelParams = [
    "console=ttyS2,1500000n8"
    "earlycon=uart8250,mmio32,0xff1a0000"
    "earlyprintk"
    "loglevel=7"
  ];

  # {{{

  # See also Debians state of the art:
  # https://wiki.debian.org/InstallingDebianOn/Kobol/Helios64
  nixpkgs.config.packageOverrides = pkgs:
    { linux_helios64 = pkgs.linux_5_9.override {
        kernelPatches = [
          # these patches are from https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/log/?h=v5.11-armsoc/dts64
          # maybe we should just grab the armbian rock64 ones?
          # https://github.com/armbian/build/tree/master/patch/kernel/rockchip64-current
          { name = "dt-bindings: vendor-prefixes: Add kobol prefix"; patch = ./patches/kernel/fa67f2817ff2c9bb07472d30e58d904922f1a538.patch; }
          # { name = "arm64: dts: rockchip: Add basic support for Kobol's Helios64"; patch = ./patches/kernel/09e006cfb43e8ec38afe28278b210dab72e6cac8.patch; }
          { name = "dt-bindings: arm: rockchip: Add Kobol Helios64"; patch = ./patches/kernel/62dbf80fc581a8eed7288ed7aca24446054eb616.patch; }
          # See https://github.com/armbian/build/commit/edb45f9acf322fc4b27bf7efba3f14a3a432b617#diff-7a730180ed2f704b5c164272e74136fdf774ab8fcb6039aa310645dd2be8e3e6
          { name = "Add board Helios64"; patch = ./patches/kernel/add-board-helios64.patch; }

          { name = "Remove PCIE ep-gpios from Helios64"; patch = ./patches/kernel/helios64-remove-pcie-ep-gpios.patch; }
          { name = "PCI: rockchip: support ep-gpio undefined case"; patch = ./patches/kernel/rk3399-pci-rockchip-support-ep-gpio-undefined-case.patch; }
        ];
        extraConfig =
          ''
          INPUT_GPIO_BEEPER m
          GPIO_PCA953X y
          GPIO_PCA953X_IRQ y
          GENERIC_ADC_BATTERY m

          ARM_AMBA y
          HAVE_PCI y

          USB_GADGETFS m
          USB_MASS_STORAGE m
          USB_G_SERIAL m
          USB_G_HID m
          USB_ROLE_SWITCH m
          MMC y
          PWRSEQ_EMMC y
          PWRSEQ_SD8787 m
          PWRSEQ_SIMPLE y
          MMC_BLOCK y
          MMC_BLOCK_MINORS 16
          MMC_TEST y
          MMC_SDHCI y
          MMC_SDHCI_IO_ACCESSORS y
          MMC_SDHCI_PLTFM y
          MMC_SDHCI_OF_ASPEED m
          MMC_SDHCI_OF_DWCMSHC m
          MMC_SDHCI_CADENCE m
          MMC_SDHCI_MILBEAUT m
          MMC_DW y
          MMC_DW_PLTFM y
          MMC_DW_BLUEFIELD m
          MMC_DW_ROCKCHIP y
          MMC_REALTEK_USB m
          '';
      };
  };

  # }}}

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_10_helios64;
  # boot.initrd.availableKernelModules = [ "nvme" "pcie-rockchip-host" ];
  # boot.kernelModules = [ "pcie-rockchip-host" ];

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enable = true;

  networking.firewall.enable = true;

  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = true;
}
