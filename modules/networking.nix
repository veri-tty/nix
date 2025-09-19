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
      enable = lib.mkEnableOption "Enable Tailscale VPN";
    };
    headscale = {
      enable = lib.mkEnableOption "Enable Headscale VPN";
    };
    mullvad = {
      enable = lib.mkEnableOption "Enable Mullvad VPN";
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
    services.headscale = lib.mkIf config.headscale.enable {
      enable = true;
      settings.dns.base_domain = "https://headnet.lunau.xyz";
    };


    # Tailscale configuration
    services.tailscale = lib.mkIf config.tailscale.enable {
      enable = true;
      extraUpFlags = [
        "--ssh"
        "--hostname=${config.networking.hostName}"
      ];
    };

    services.mullvad-vpn = lib.mkIf config.mullvad.enable {
      enable = true;
      package = pkgs.mullvad-vpn; # gui
    };
  };
}
