{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    development = {
      enable = lib.mkEnableOption "Enable development tools";
      vscode = {
        enable = lib.mkEnableOption "Enable Visual Studio Code";
      };
      git = {
        enable = lib.mkEnableOption "Enable Git configuration";
      };
      nodejs = {
        enable = lib.mkEnableOption "Enable Node.js development tools";
      };
      python = {
        enable = lib.mkEnableOption "Enable Python development tools";
      };
      zed = {
        enable = lib.mkEnableOption "Enable Zed IDE";
      };
      rust = {
        enable = lib.mkEnableOption "Enable Rust Toolchain";
      };
    };
  };

  config = {
    # Git configuration
    home-manager.users.ml.programs.git = lib.mkIf (config.development.enable && config.development.git.enable) {
      enable = true;
      userName = "veri-tty";
      userEmail = "verity@cock.li";
    };

    home-manager.users.ml.programs.zed-editor = lib.mkIf config.development.zed.enable {
              enable = true;
    };

    # Development tools
    home-manager.users.ml.home.packages = lib.mkIf config.development.enable (
      (lib.optionals config.development.vscode.enable [
        pkgs.vscode
      ])
      ++ (lib.optionals config.development.nodejs.enable [
        pkgs.nodejs_23
        pkgs.node2nix
      ])
      ++ (lib.optionals config.development.python.enable [
        pkgs.python3
      ])
      ++ [
        # General development tools
        pkgs.cachix
        pkgs.alejandra # nix formatter
        pkgs.nixd

      ]
    );
  environment.systemPackages = lib.mkIf config.development.rust.enable [ pkgs.rustc pkgs.rustfmt ];

  };
}
