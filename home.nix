{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland.nix
  ];

  # Basic home configuration
  home.username = "ml";
  home.homeDirectory = "/home/ml";
  home.stateVersion = "24.11";

  # Firefox-based browser configuration
  programs.floorp = {
    enable = true;
    profiles = {
      tech = {
        id = 0;
        name = "tech";
        isDefault = true;
        path = "tech.default";
        extensions.packages = with inputs.rycee.packages.x86_64-linux; [
          bitwarden
          ublock-origin
          privacy-badger
          linkwarden
        ];
      };
    };
  };

  # Packages that should be installed to the user profile, organized by category
  home.packages = with pkgs; [
    # System packages from configuration.nix
    pw-volume
    nerd-fonts.sauce-code-pro
    feather
    node2nix
    nodejs_23

    # External inputs
    inputs.nvf.packages."${system}".default
    inputs.zen-browser.packages."${system}".default

    # Desktop applications
    vscode
    spotify
    obsidian
    remmina # rdp client
    bambu-studio

    # Terminal and shell utilities
    neofetch
    nnn # terminal file manager
    alejandra # nix formatter
    cowsay

    # Development tools
    python3
    cachix
    docker-compose

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

    # Crypt Wallets
    electrum # btc
    feather # xmr

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
    wireshark # A network protocol analyzer
    tcpdump # A network packet analyzer
    gopro

    # Security tools
    gnupg

    # Nix related
    nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output

    # Productivity
    hugo # static site generator
    glow # markdown previewer in terminal

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

  # Terminal emulator configuration
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 17;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;

      colors = {
        primary = {
          background = "#24273a";
          foreground = "#cad3f5";
          dim_foreground = "#8087a2";
          bright_foreground = "#cad3f5";
        };

        cursor = {
          text = "#24273a";
          cursor = "#f4dbd6";
        };

        vi_mode_cursor = {
          text = "#24273a";
          cursor = "#b7bdf8";
        };

        search = {
          matches = {
            foreground = "#24273a";
            background = "#a5adcb";
          };

          focused_match = {
            foreground = "#24273a";
            background = "#a6da95";
          };
        };

        footer_bar = {
          foreground = "#24273a";
          background = "#a5adcb";
        };

        hints = {
          start = {
            foreground = "#24273a";
            background = "#eed49f";
          };

          end = {
            foreground = "#24273a";
            background = "#a5adcb";
          };
        };

        selection = {
          text = "#24273a";
          background = "#f4dbd6";
        };

        normal = {
          black = "#494d64";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#b8c0e0";
        };

        bright = {
          black = "#5b6078";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#a5adcb";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#f5a97f";
          }
          {
            index = 17;
            color = "#f4dbd6";
          }
        ];
      };
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
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#fitz";
      thm = "sudo openvpn --config /home/ml/projects/thm/verityl.ovpn";
    };
  };

  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
