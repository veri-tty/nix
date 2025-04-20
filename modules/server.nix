{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    server = {
      immich = {
        enable = lib.mkEnableOption "Enable baremetal immich via nixpkgs";
      };
      vaultwarden = {
        enable = lib.mkEnableOption "Enable vaultwarden via nixpkgs";
      };
    };
  };

  config = {
    # Basic service configuration
      services.immich = lib.mkIf config.server.immich.enable {
        enable = true;
      };

      services.vaultwarden = lib.mkIf config.server.vaultwarden.enable {
        enable = true;
      };

      services.bitwarden-directory-connector-cli.domain = lib.mkIf config.server.vaultwarden.enable "vault.lunau.xyz";
      # Open firewall ports
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    };
}
