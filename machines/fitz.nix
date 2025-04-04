{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  networking.hostName = "fitz";

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ad546470-e4bd-443f-b243-2d30bf001005";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-24f96f23-bc4c-4c57-8b22-265c3ce50c22".device = "/dev/disk/by-uuid/24f96f23-bc4c-4c57-8b22-265c3ce50c22";
  boot.initrd.luks.devices."luks-65d679f5-952e-4289-85e2-1d947410a095".device = "/dev/disk/by-uuid/65d679f5-952e-4289-85e2-1d947410a095";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7C44-BC68";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/bbdea9bb-0219-4aeb-b6f5-ae8ad7bf9d53";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0f0u1u1c2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
