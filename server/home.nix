{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Basic home configuration
  home.username = "ml";
  home.homeDirectory = "/home/ml";
  home.stateVersion = "24.11";

  # Packages that should be installed to the user profile, organized by category
  home.packages = with pkgs; [
    # Terminal and shell utilities
    neofetch
    nnn # terminal file manager
    alejandra # nix formatter

    # Development tools
    python3
    cachix
    docker-compose
    git

    # Archives and compression
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar

    # File and text utilities
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor
    eza # A modern replacement for 'ls'
    fzf # A command-line fuzzy finder
    file
    which
    tree
    gnused
    gawk

    # Networking tools
    openvpn
    inetutils
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # Security tools
    gnupg

    # Nix related
    nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output

    # System monitoring and debugging
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "veri-tty";
    userEmail = "verity@cock.li";
  };

  # Shell prompt customization
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # Bash shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#kerberos";
    };
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#kerberos";
    };
    shellInit = ''
      set -U fish_greeting # Disable greeting
    '';
  };

  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
