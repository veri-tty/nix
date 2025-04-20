{
  config,
  lib,
  pkgs,
  ...
}: {
    config = {
    # Basic service configuration
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    };
}
