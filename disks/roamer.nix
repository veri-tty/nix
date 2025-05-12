# Disk configuration for roamer (laptop)
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  config = lib.mkIf (config.networking.hostName == "roamer" && config.disko.enable) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1"; # Typical NVMe device for laptops
          content = {
            type = "gpt";
            partitions = {
              boot = {
              name = "boot";
              size = "500M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            luks = {
              name = "luks";
              size = "100%"; # Use remaining space
              content = {
                type = "luks";
                name = "crypt"; # Match the existing luks name in the config
                extraOpenArgs = ["--allow-discards"]; # For SSD TRIM
                
                # Include cryptoModules from the existing config
                cryptoModules = [
                  "aes"
                  "aes_generic"
                  "blowfish"
                  "twofish"
                  "serpent"
                  "cbc"
                  "xts"
                  "lrw"
                  "sha1"
                  "sha256"
                  "sha512"
                  "af_alg"
                  "algif_skcipher"
                ];
                
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
  };
}