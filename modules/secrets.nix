{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    secrets = {
      enable = lib.mkEnableOption {
        description = "Enable secrets management with sops-nix";
        default = false;
      };
    };
  };

  config = lib.mkIf config.secrets.enable {
    # Add age tools for encryption/decryption
    environment.systemPackages = [
      pkgs.age
      pkgs.sops
    ];
    sops = {
      # Default age key location
      age.keyFile = lib.mkDefault "/home/ml/.config/sops/age/keys.txt";

      # For initial setup or testing, we'll use a fallback mechanism
      # Note: this allows the module to work even without proper keys
      age.generateKey = true; # Generate a key if it doesn't exist
      
      # Make secrets available to the specified user
      defaultSopsFile = ../secrets/secrets.yaml;
      
      # Configure secrets
      secrets = {
        # Tailscale auth key
        "tailscale/authkey" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
        
        # SSH private key
        "ssh/id_ed25519" = {
          owner = "ml";
          group = "users";
          mode = "0400";
          path = "/home/ml/.ssh/id_ed25519";
        };
        
        # SSH known hosts
        "ssh/known_hosts" = {
          owner = "ml";
          group = "users";
          mode = "0444";
          path = "/home/ml/.ssh/known_hosts";
        };
        
        # WiFi networks (if needed)
        "network/wifi_networks" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
        
        # Add more secrets as needed
      };
    };
    
    # Tailscale integration with the secret
    services.tailscale = lib.mkIf config.tailscale.enable {
      enable = true;
      authKeyFile = config.sops.secrets."tailscale/authkey".path;
      extraUpFlags = [
        "--ssh"
        "--hostname=${config.networking.hostName}"
      ];
    };
  };
}