{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    docker = {
      enable = lib.mkEnableOption "docker or not.";
    };
    qemu = {
      enable = lib.mkEnableOption "qemu or not.";
    };
  };
  config = {
    virtualisation = lib.mkIf config.docker.enable {
      docker.enable = true;
      docker.autoPrune.enable = true;
    };

    environment.systemPackages = lib.mkMerge [
      (lib.mkIf config.docker.enable (with pkgs; [
        docker-compose
        compose2nix
      ]))

      (lib.mkIf config.qemu.enable [
        pkgs.qemu
        pkgs.quickemu
      ])
    ];
    programs.tmux.enable = lib.mkIf config.qemu.enable true;
  };
}
