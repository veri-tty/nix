{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./pentesting.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking.networkmanager.enable = true;

  # Localization and time
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Keyboard layout
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Nix features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#fitz";
      thm = "sudo openvpn --config /home/ml/projects/thm/verityl.ovpn";
      claude = "/home/ml/.npm-packages/bin//claude";
    };
  };

  # System services
  services = {
    # Networking services
    tailscale.enable = true;
    syncthing = {
      enable = true;
      user = "ml";
      dataDir = "/home/ml"; # default location for new folders
      configDir = "/home/ml/.config/syncthing";
    };

    # Desktop environment (disabled)
    xserver = {
      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = false;
    };

    # Printing
    printing.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };

  # Theme
  catppuccin = {
    flavor = "mocha";
    enable = true;
  };

  # Security
  security.rtkit.enable = true;

  # User configuration
  users.users.ml = {
    isNormalUser = true;
    description = "ml";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Hardware configuration
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module
    open = true;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Package management
  nixpkgs.config.allowUnfree = true;

  # Gaming and desktop support
  programs.steam.enable = true;
  programs.hyprland.enable = true;

  # System state version
  system.stateVersion = "24.11"; # Did you read the comment?
}
