{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    docker = {
      enable = lib.mkEnableOption {
        description = "docker or not.";
        default = false;
      };
    };
  };
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
