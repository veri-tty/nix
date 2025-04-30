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
    qemu = {
      enable = lib.mkEnableOption {
        description = "qemu or not.";
        default = false;
      };
    };
  };
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
     virtualisation.docker.autoPrune.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      compose2nix
    ];
  };
  environment = lib.mkIf config.qemu.enable {
      systemPackages = [
        pkgs.qemu
        pkgs.quickemu
      ];
    };
}
