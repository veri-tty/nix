{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.displayManager.setup;
in {
  options.services.displayManager.setup = {
    enable = mkEnableOption "common display manager configuration";

    defaultSession = mkOption {
      type = types.str;
      default = "";
      description = "Default session to use (leave empty for user choice)";
    };

    autoLogin = {
      enable = mkEnableOption "autologin";

      user = mkOption {
        type = types.str;
        default = "";
        description = "User to automatically log in";
      };

      session = mkOption {
        type = types.str;
        default = "";
        description = "Session to use for autologin";
      };
    };

    theme = {
      enable = mkEnableOption "custom SDDM theme";

      package = mkOption {
        type = types.package;
        default = pkgs.libsForQt5.sddm-kcm;
        defaultText = "pkgs.libsForQt5.sddm-kcm";
        description = "The SDDM theme package to use";
      };

      name = mkOption {
        type = types.str;
        default = "breeze";
        description = "The name of the SDDM theme to use";
      };
    };
  };

  config = mkIf cfg.enable {
    # For newer NixOS versions, display manager options have moved
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = mkMerge [
        (mkIf cfg.autoLogin.enable {
          Autologin = {
            Session = cfg.autoLogin.session;
            User = cfg.autoLogin.user;
          };
        })
        (mkIf cfg.theme.enable {
          Theme = {
            Current = cfg.theme.name;
          };
        })
      ];
      # By default, no autoLogin settings means SDDM will show at boot
    };

    services.displayManager.defaultSession = mkIf (cfg.defaultSession != "") cfg.defaultSession;

    # Install SDDM theme
    environment.systemPackages = mkIf cfg.theme.enable [
      cfg.theme.package
    ];
  };
}