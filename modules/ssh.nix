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
    # Allow root login
    services.openssh.permitRootLogin = false;
    # Allow password authentication
    services.openssh.passwordAuthentication = false;
    # Allow public key authentication
    users.users.ml.openssh.authorizedKeys.keys = [
      # Add your public key here
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE9ceLKI4j5i1tNU/jvMST0vvbGrn6azbtFrrelokQd ml@fitz"
    ];
  };
}
