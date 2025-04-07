# Template for machine configuration
# Copy this file to create a new machine and adjust settings as needed
{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    # Import hardware detection
    (modulesPath + "/installer/scan/not-detected.nix")
    # Import all modules
    ../modules
  ];

  # Machine identification
  networking.hostName = "machine-name";

  # Module configuration - Base options
  hyprland.enable = true; # Window manager
  floorp.enable = true; # Web browser
  shell.enable = true; # ZSH shell
  docker.enable = true; # Docker virtualization
  networkmanager.enable = true; # NetworkManager
  tailscale.enable = false; # Tailscale VPN
  mullvad.enable = false; # Mullvad VPN
  locale.enable = true; # Locale settings
  nvidia.enable = false; # NVIDIA drivers
  syncthing.enable = false; # Syncthing file sync
  samba.enable = false; # Samba file sharing
  pentesting.enable = false; # Pentesting tools

  # Terminal configurations
  terminal = {
    enable = true;
    alacritty.enable = true; # Alacritty terminal
    starship.enable = true; # Starship prompt
  };

  # Development tools
  development = {
    enable = true;
    git.enable = true; # Git version control
    vscode.enable = true; # Visual Studio Code
    nodejs.enable = true; # Node.js
    python.enable = true; # Python
  };

  # Utility tools
  utilities = {
    enable = true;
    compression.enable = true; # Compression tools
    text.enable = true; # Text processing tools
    system.enable = true; # System monitoring
    nix.enable = true; # Nix-specific tools
  };

  # Desktop applications
  applications = {
    enable = true;
    office.enable = true; # Office applications
    media.enable = true; # Media applications
    crypto.enable = false; # Cryptocurrency wallets
    printing.enable = false; # 3D printing tools
  };

  # Networking tools
  networking-tools = {
    enable = true;
    vpn.enable = false; # VPN clients
    analysis.enable = false; # Network analysis tools
  };

  # Hardware configuration
  # Replace this section with the hardware details from your machine
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    # { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID"; }
  ];
}
