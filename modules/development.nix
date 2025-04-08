{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    development = {
      enable = lib.mkEnableOption {
        description = "Enable development tools";
        default = false;
      };
      vscode = {
        enable = lib.mkEnableOption {
          description = "Enable Visual Studio Code";
          default = false;
        };
      };
      git = {
        enable = lib.mkEnableOption {
          description = "Enable Git configuration";
          default = false;
        };
      };
      nodejs = {
        enable = lib.mkEnableOption {
          description = "Enable Node.js development tools";
          default = false;
        };
      };
      python = {
        enable = lib.mkEnableOption {
          description = "Enable Python development tools";
          default = false;
        };
      };
      zed = {
        enable = lib.mkEnableOption {
          description = "Enable Zed IDE";
          default = false;
        };
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
      extensions = [
        "nix"
        "catppuccin-blur-plus"
      ];
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
      ]
    );
  };
}
