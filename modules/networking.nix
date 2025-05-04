{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    networkmanager = {
      enable = lib.mkEnableOption {
        description = "Enable NetworkManager";
        default = true;
      };
    };
    tailscale = {
      enable = lib.mkEnableOption {
        description = "Enable Tailscale VPN";
        default = false;
      };
    };
    mullvad = {
      enable = lib.mkEnableOption {
        description = "Enable Mullvad VPN";
        default = false;
      };
    };
  };

  config = {
    ## Enable network manager
    networking.networkmanager.enable = lib.mkIf config.networkmanager.enable true;
    environment.systemPackages = [ pkgs.openvpn ];


    ## Enabling appropriate groups
    users.users.ml = lib.mkIf config.networkmanager.enable {
      extraGroups = ["networkmanager"];
    };

    services.tailscale.enable = lib.mkIf config.tailscale.enable true;

    services.mullvad-vpn = lib.mkIf config.mullvad.enable {
      enable = true;
      package = pkgs.mullvad-vpn; # gui
    };
  };
}
