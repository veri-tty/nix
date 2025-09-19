{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    floorp = {
      enable = lib.mkEnableOption "Enable Floorp";
    };
    schizofox = {
      enable = lib.mkEnableOption "Enable the schizo browser";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf config.floorp.enable {
      home-manager.users.ml.programs.floorp = {
        enable = true;
        profiles = {
          tech = {
            id = 0;
            name = "tech";
            isDefault = true;
            path = "tech.default";
            extensions.packages = with inputs.rycee.packages.x86_64-linux; [
              bitwarden
              ublock-origin
              privacy-badger
              linkwarden
            ];
          };
          velor = {
            id = 1;
            name = "velor";
            isDefault = false;
            path = "velor.default";
            extensions.packages = with inputs.rycee.packages.x86_64-linux; [
              bitwarden
              ublock-origin
              privacy-badger
              linkwarden
            ];
          };
          lost = {
            id = 2;
            name = "lost";
            isDefault = false;
            path = "lost.default";
            extensions.packages = with inputs.rycee.packages.x86_64-linux; [
              bitwarden
              ublock-origin
              privacy-badger
              linkwarden
            ];
          };
        };
      };
    })
    (lib.mkIf config.schizofox.enable {
      home-manager.users.ml = {
        imports = [
          inputs.schizofox.homeManagerModules.default
        ];
        programs.schizofox = {
        enable = true;
        theme = {
          colors = {
            # Catppuccin Mocha
            background-darker = "11111b"; # Base (darker variant)
            background = "1e1e2e";        # Base
            foreground = "cdd6f4";        # Text
          };

          font = "Lexend";

        };

        search = {
          defaultSearchEngine = "DuckDuckGo";
          removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
          searxUrl = "https://searx.bndkt.io/";
          searxQuery = "https://searx.bndkt.io/search?q={searchTerms}&categories=general";
          addEngines = [
            {
              Name = "Marginalia";
              Description = "For good resulsts";
              Alias = "!mar";
              Method = "GET";
              URLTemplate = "https://marginalia-search.com/search?query={searchTerms}";
            }

          ];
        };

        security = {
          sanitizeOnShutdown.enable = true;
          sandbox.enable = true;
          userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
        };

        misc = {
          drm.enable= true;
          disableWebgl = false;
          #startPageURL = "file://${builtins.readFile ./startpage.html}";
          contextMenu.enable = true;
        };

        extensions = {
          simplefox.enable = true;
          darkreader.enable = true;

          extraExtensions = {
            "hoarder@hoarder".install_url= "https://files.catbox.moe/oxaepc.xpi";
            "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            "karakeep@karakeep".install_url = "https://addons.mozilla.org/firefox/downloads/latest/karakeep/latest.xpi";
          };
        };

        misc.bookmarks = [
          {
            Title = "Example";
            URL = "https://example.com";
            Favicon = "https://example.com/favicon.ico";
            Placement = "toolbar";
            Folder = "FolderName";
          }
        ];
      };
      };
    })
  ];
}
