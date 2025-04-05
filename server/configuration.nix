{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Networking
  networking = {
    hostName = "kerberos"; # Set the hostname
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
        PasswordAuthentication = true;
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE9ceLKI4j5i1tNU/jvMST0vvbGrn6azbtFrrelokQd"
    ];
  };

  # Package management
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "24.11";
}
