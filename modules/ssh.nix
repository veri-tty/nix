{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    ssh = {
      enable = lib.mkEnableOption "Enable OpenSSH server.";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKscmbcptGav35eypKUFdRdsnnTqNH4d9xtr7SykyoQJ ml@fitz"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKTxlRrPhGZnHKJZpcjLcqr1Vvod2rzZVEjgHD9oI93 ml@strelok"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/U51AA+viYJACfTPeHN/P7Prl7iqOuigtPxNvCgzX/ ml@roamer"
    ];
  };
}
