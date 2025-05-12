# Disk configuration for kerberos (server)
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  config = lib.mkIf (config.networking.hostName == "kerberos" && config.disko.enable) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/sda"; # Default primary disk in a VM/server environment
          content = {
            type = "gpt";
            partitions = {
              boot = {
              name = "boot";
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            swap = {
              name = "swap";
              size = "8G"; # Adjust based on server RAM
              content = {
                type = "swap";
                randomEncryption = false; # Typically not needed for servers
              };
            };
            root = {
              name = "root";
              size = "100%"; # Use remaining space
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
  };
}