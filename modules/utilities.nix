{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    utilities = {
      enable = lib.mkEnableOption "Enable utility packages";
      compression = {
        enable = lib.mkEnableOption "Enable compression tools";
      };
      text = {
        enable = lib.mkEnableOption "Enable text processing tools";
      };
      system = {
        enable = lib.mkEnableOption "Enable system monitoring tools";
      };
      nix = {
        enable = lib.mkEnableOption "Enable Nix-specific tools";
      };
      server = {
        enable = lib.mkEnableOption "Enable soem tools i use to interact with my servers";
      };
    };
  };

  config = {
    home-manager.users.ml.home.packages = lib.mkIf config.utilities.enable (
      (lib.optionals config.utilities.compression.enable [
        # Archives and compression
        pkgs.zip
        pkgs.xz
        pkgs.unzip
        pkgs.p7zip
        pkgs.zstd
        pkgs.gnutar
      ]) ++
      (lib.optionals config.utilities.text.enable [
        # File and text utilities
        pkgs.ripgrep # recursively searches directories for a regex pattern
        pkgs.jq # A lightweight and flexible command-line JSON processor
        pkgs.yq-go # yaml processor
        pkgs.eza # A modern replacement for 'ls'
        pkgs.fzf # A command-line fuzzy finder
        pkgs.file
        pkgs.which
        pkgs.tree
        pkgs.gnused
        pkgs.gawk
        pkgs.glow # markdown previewer in terminal
      ]) ++
      (lib.optionals config.utilities.system.enable [
        # System monitoring and debugging
        pkgs.btop # replacement of htop/nmon
        pkgs.iotop # io monitoring
        pkgs.iftop # network monitoring
        pkgs.strace # system call monitoring
        pkgs.ltrace # library call monitoring
        pkgs.lsof # list open files
        pkgs.sysstat
        pkgs.lm_sensors # for `sensors` command
        pkgs.ethtool
        pkgs.pciutils # lspci
        pkgs.usbutils # lsusb
        pkgs.neofetch
        pkgs.nnn # terminal file manager
      ]) ++
      (lib.optionals config.utilities.nix.enable [
        # Nix related
        pkgs.nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
      ])++
      (lib.optionals config.utilities.server.enable [
      pkgs.immich-go
      pkgs.wget
      ])
    );
  };
}
