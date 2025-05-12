# Disk configuration for fitz
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  config = lib.mkIf (config.networking.hostName == "fitz" && config.disko.enable) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-main"; # Change to match actual disk identifier
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
                    "fmask=0077"
                    "dmask=0077"
                  ];
                };
              };
              luks = {
                name = "luks";
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  extraOpenArgs = ["--allow-discards"]; # For SSD TRIM

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