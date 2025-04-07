{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules
  ];

  # Machine identification
  networking.hostName = "roamer";

  # Module configuration
  hyprland.enable = true;
  floorp.enable = true;
  shell.enable = true;
  docker.enable = false;
  networkmanager.enable = true;
  tailscale.enable = false;
  mullvad.enable = true;
  locale.enable = true;
  nvidia.enable = false;
  syncthing.enable = true;
  samba.enable = false;
  pentesting.enable = true;

  # Terminal configurations
  terminal = {
    enable = true;
    alacritty.enable = true;
    starship.enable = true;
  };

  # Development tools
  development = {
    enable = true;
    git.enable = true;
    vscode.enable = true;
    nodejs.enable = true;
    python.enable = true;
  };

  # Utility tools
  utilities = {
    enable = true;
    compression.enable = true;
    text.enable = true;
    system.enable = true;
    nix.enable = true;
  };

  # Desktop applications
  applications = {
    enable = true;
    office.enable = true;
    media.enable = true;
    crypto.enable = false;
    printing.enable = false;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.initrd.luks.cryptoModules = [
    "aes"
    "aes_generic"
    "blowfish"
    "twofish"
    "serpent"
    "cbc"
    "xts"
    "lrw"
    "sha1"
    "sha256"
    "sha512"
    "af_alg"
    "algif_skcipher"
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "8250_dw"
    "surface_hid"
    "intel_lpss"
    "intel_lpss_pci"
    "pinctrl_icelake"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2448b62d-fba4-4bcd-ac71-70d7284e5141";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."crypt".device = "/dev/nvme0n1p2";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8EFB-4D8F";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];
}
