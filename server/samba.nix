{
  config,
  pkgs,
  ...
}: {
  # Samba configuration based on NixOS Wiki
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = Kerberos Server
      netbios name = kerberos
      security = user
      
      # Use sendfile
      use sendfile = yes
      
      # Set directory mask to ensure proper permissions
      directory mask = 0770
      create mask = 0660
      
      # Disable printing services
      load printers = no
      printing = bsd
      printcap name = /dev/null
      disable spoolss = yes
    '';
    
    shares = {
      public = {
        path = "/mnt/storage/public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
      
      private = {
        path = "/mnt/storage/private";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "valid users" = "ml";
      };
    };
  };

  # Open firewall ports for Samba
  networking.firewall = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };

  # Create storage directories
  systemd.tmpfiles.rules = [
    "d /mnt/storage 0770 ml users -"
    "d /mnt/storage/public 0770 ml users -"
    "d /mnt/storage/private 0770 ml users -"
  ];
}