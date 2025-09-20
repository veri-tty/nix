{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    ssh.server = {
      enable = lib.mkEnableOption "Enable OpenSSH server for server or smthng idfk.";
    };
    ssh.client = {
      enable = lib.mkEnableOption "Ssh client and shii";
    };
  };
  config = {
  home-manager.users.ml.programs.ssh = lib.mkIf config.ssh.client.enable {
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "/home/ml/.ssh/github";
        extraOptions = {
        PreferredAuthentications = "publickey";
        };
      };  
    };
  }; 
  services.openssh = lib.mkIf config.ssh.server.enable {
    # Enable OpenSSH server
    enable = true;
    # disallow root login
    permitRootLogin = "no";
    # Allow password authentication
    passwordAuthentication = false;
    # Allow public key authentication
    #users.users.ml.openssh.authorizedKeys.keys = [
      # Add your public key here
      #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKscmbcptGav35eypKUFdRdsnnTqNH4d9xtr7SykyoQJ ml@fitz"
      #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKTxlRrPhGZnHKJZpcjLcqr1Vvod2rzZVEjgHD9oI93 ml@strelok"
      #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/U51AA+viYJACfTPeHN/P7Prl7iqOuigtPxNvCgzX/ ml@roamer"
    #];
  };
};
}

