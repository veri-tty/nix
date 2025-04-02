{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland.nix
  ];
  # TODO please change the username & home directory to your own
  home.username = "ml";
  home.homeDirectory = "/home/ml";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

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
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    inputs.nvf.packages."${system}".default
    inputs.zen-browser.packages."${system}".default
    vscode
    neofetch
    nnn # terminal file manager
    openvpn
    alejandra

    obsidian

    spotify
    remmina # rdp
    # archives
    zip
    inetutils
    cachix
    xz
    unzip
    p7zip
    gopro
    python3

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
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

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    bambu-studio
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "veri-tty";
    userEmail = "verity@cock.li";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/flake#fitz";
      thm = "sudo openvpn --config /home/ml/projects/thm/verityl.ovpn";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
