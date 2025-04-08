{
  lib,
  config,
  ...
}: {
  imports = [
    ./nvidia-gpu.nix
    ./pentesting.nix
    ./filesync.nix
    ./networking.nix
    ./virtualisation.nix
    ./nixos.nix
    ./zsh.nix
    ./locale.nix
    ./hyprland.nix
    ./browsers.nix
    ./terminal.nix
    ./development.nix
    ./utilities.nix
    ./applications.nix
    ./ssh.nix
  ];
}
