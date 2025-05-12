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
  hardware.bluetooth.enable = true;

  # Module configuration
  hyprland.enable = true;
  floorp.enable = true;
  schizofox.enable = true;
  shell.enable = true;
  docker.enable = false;
  networkmanager.enable = true;
  tailscale.enable = true;
  mullvad.enable = true;
  nvidia.enable = false;
  themeing.enable = true;
  syncthing.enable = true;
  samba.enable = false;
  pentesting.enable = true;
  disko.enable = false; # Only enable during installation
  #secrets.enable = true;
  wallpaper = "/home/ml/pics/wall/wallhaven-qzyyxd.png";
  display = "eDP-1";

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
    zed.enable = true;
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
    device = "/dev/disk/by-uuid/d4a78e89-46b3-45de-8802-bb2e66970012";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/edfeda0f-fc4d-4582-b9d5-5b00fa538f64";
  boot.loader.systemd-boot.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E778-08F8";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];
}
