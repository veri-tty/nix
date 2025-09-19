{
  config,
  pkgs,
  modulesPath,
  inputs,
  lib,
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
  kde.enable = true; # Enable KDE Plasma desktop
  floorp.enable = true;
  schizofox.enable = true;
  shell.enable = true;
  docker.enable = true;
  networkmanager.enable = true;
  tailscale.enable = true;
  mullvad.enable = true;
  nvidia.enable = true;
  syncthing.enable = true;
  samba.enable = false;
  pentesting.enable = true;
  disko.enable = false; # Only enable during installation
  wallpaper = "/home/ml/pics/wall/wallhaven-jx632y.jpg";

  # Display manager settings for KDE
  services.displayManager.setup = {
    enable = true;
    defaultSession = "plasma";
    theme = {
      enable = true;
      name = "breeze";
    };
  };

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
    device = "/dev/disk/by-uuid/c6838a99-4127-42d2-b162-c57685dea4f5";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-f9f1ff11-8d78-42af-8a05-ed9be5fecffd".device = "/dev/disk/by-uuid/f9f1ff11-8d78-42af-8a05-ed9be5fecffd";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5721-1293";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

#  swapDevices = [
#    {device = "/dev/disk/by-uuid/8c8a2b69-d437-4002-817e-10a1bd6e32b0";}
#  ];

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
