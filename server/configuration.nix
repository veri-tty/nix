{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Networking
  networking = {
    useDHCP = false; # Disable DHCP globally
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          # Replace with your server's IP
          {
            address = "0.0.0.0";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = "0.0.0.0"; # Replace with your gateway
    nameservers = ["1.1.1.1" "8.8.8.8"];
    firewall = {
      enable = true;
      # Open ssh port
      allowedTCPPorts = [22];
    };
  };

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

  # Nix features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#kerberos";
    };
  };

  # System services
  services = {
    # SSH server
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Networking services
    tailscale.enable = true;
    syncthing = {
      enable = true;
      user = "ml";
      dataDir = "/home/ml"; # default location for new folders
      configDir = "/home/ml/.config/syncthing";
    };
  };

  # Docker support
  virtualisation.docker.enable = true;

  # User configuration
  users.users.ml = {
    isNormalUser = true;
    description = "ml";
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeUv..."
    ];
  };

  # Package management
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "24.11";
}
