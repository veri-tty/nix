{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    ssh = {
      enable = lib.mkEnableOption {
        description = "Enable OpenSSH server.";
        default = false;
      };
    };
  };
  config = lib.mkIf config.ssh.enable {
    # Enable OpenSSH server
    services.openssh.enable = true;
    # disallow root login
    services.openssh.permitRootLogin = "no";
    # Allow password authentication
    services.openssh.passwordAuthentication = false;
    # Allow public key authentication
    users.users.ml.openssh.authorizedKeys.keys = [
      # Add your public key here
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE9ceLKI4j5i1tNU/jvMST0vvbGrn6azbtFrrelokQd ml@fitz"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJP0Np8JTHo75Gf4Gf7CU34EytXHxGgORyqGDK1vazR8 ml@roamer"
    ];
  };
}
