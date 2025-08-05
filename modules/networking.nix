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
    headscale = {
      enable = lib.mkEnableOption {
        description = "Enable Headscale VPN";
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
    services.headscale = lib.mkIf config.headscale.enable {
      enable = true;
      settings.dns.base_domain = "headnet.lunau.xyz";
    };


    # Tailscale configuration with secrets integration
    services.tailscale = lib.mkIf config.tailscale.enable {
      enable = true;

      # Use the authkey from sops-nix if secrets are enabled
      # authKeyFile = lib.mkIf config.secrets.enable
      #   config.sops.secrets."tailscale/authkey".path;

      # Common options for all machines
      extraUpFlags = [
        "--ssh"
        "--hostname=${config.networking.hostName}"
      ];
    };

    # WiFi networks from secrets (if applicable)
    networking.wireless = lib.mkIf (config.secrets.enable && config.networkmanager.enable) {
      secretsFile = config.sops.secrets."network/wifi_networks".path;
    };

    services.mullvad-vpn = lib.mkIf config.mullvad.enable {
      enable = true;
      package = pkgs.mullvad-vpn; # gui
    };
  };
}
