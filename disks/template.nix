# Template disk configuration
# Copy this file to create a new disk config for a machine
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";  # Change to match your disk
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "500M";
              type = "EF00";  # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            swap = {
              name = "swap";
              size = "8G";  # Adjust based on your system RAM
              content = {
                type = "swap";
                randomEncryption = true;  # Optional: encrypt swap
              };
            };
            root = {
              name = "root";
              size = "100%";  # Use remaining space
              content = {
                type = "luks";  # Optional: encrypted root
                name = "cryptroot";
                extraOpenArgs = [ "--allow-discards" ];  # For SSD TRIM
                
                # For non-encrypted, use:
                # type = "filesystem";
                # format = "ext4";
                
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