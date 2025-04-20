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
      proxy = {
        enable = lib.mkEnableOption "Enable traefik reverse proxy via nixpkgs";
      };
    };
  };
  config = {
    services.immich = lib.mkIf config.server.immich.enable {
      enable = true;
    };
    services.vaultwarden = lib.mkIf config.server.vaultwarden.enable {
      enable = true;
    };
    services.bitwarden-directory-connector-cli.domain = lib.mkIf config.server.vaultwarden.enable "vault.lunau.xyz";


    networking.firewall.allowedTCPPorts = lib.mkIf config.server.proxy.enable [80 443];
  };
}
