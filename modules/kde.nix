{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.kde;
in {
  options.kde = {
    enable = mkEnableOption "KDE Plasma desktop environment";

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional KDE packages to install";
    };
  };

  config = mkIf cfg.enable {
    # Enable X11 and KDE Plasma
    services.xserver = {
      enable = true;

      # Enable KDE Plasma Desktop Environment
      desktopManager.plasma5 = {
        enable = true;
      };
    };

    # Set displayManager to use SDDM with KDE
    services.displayManager.setup = {
      enable = true;
      defaultSession = "plasma";
    };

    # Install KDE applications
    environment.systemPackages = with pkgs; [
      # Core KDE applications
      libsForQt5.plasma-nm
      libsForQt5.plasma-pa
      libsForQt5.kdeconnect-kde
      libsForQt5.dolphin
      libsForQt5.konsole
      libsForQt5.spectacle
      libsForQt5.okular

      # Additional KDE apps and utilities
      libsForQt5.ark
      libsForQt5.kcalc

      # Include user-specified extra packages
    ] ++ cfg.extraPackages;
  };
}