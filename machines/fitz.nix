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
  networking.hostName = "fitz";

  # Module configuration
  hyprland.enable = true;
  floorp.enable = true;
  shell.enable = true;
  docker.enable = true;
  networkmanager.enable = true;
  tailscale.enable = true;
  mullvad.enable = true;
  nvidia.enable = true;
  syncthing.enable = true;
  samba.enable = false;
  pentesting.enable = true;
  wallpaper = "/home/ml/pics/wall/wallhaven-jx632y.jpg";

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
    server.enable = true;
  };

  # Desktop applications
  applications = {
    enable = true;
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8e3621d5-f4e8-41d9-8647-a8cff8e2d1eb";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-8e1273aa-baec-406b-9820-4c33e93fe69f".device = "/dev/disk/by-uuid/8e1273aa-baec-406b-9820-4c33e93fe69f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2380-E5D4";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/64d36f20-2d6a-467f-9215-f41c9d035d45";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0f0u1u1c2.useDHCP = lib.mkDefault true;

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
