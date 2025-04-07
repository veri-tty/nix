{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    shell = {
      enable = lib.mkEnableOption {
        description = "Enable ZSH shell";
        default = false;
      };
    };
  };
  config = lib.mkIf config.shell.enable {
    ## Enable ZSH system wide
    programs.zsh.enable = true;

    ## add zsh to `/etc/shells'
    environment.shells = with pkgs; [zsh];

    ## Needed for completion
    environment.pathsToLink = ["/share/zsh"];

    ## Enable zsh for current user
    users.users.ml = {
      shell = pkgs.zsh;
    };

    # Add Zoxide
    home-manager.users.ml = {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.bat = {
        enable = true;
        config = {
          theme = "Dracula"; # Default theme
          pager = "less -R"; # Don't auto-exit if one screen
        };
      };
      ## ZSH configuration
      programs.zsh = {
        enable = true;
        shellAliases = {
          nrs = "sudo nixos-rebuild switch --flake /home/ml/projects/nix#";
          cat = "bat";
          claude = "/home/ml/.npm-packages/bin//claude";
        };

        ## Enable some QOL features
        autosuggestion.enable = true;
        enableCompletion = true;
        historySubstringSearch.enable = true;
        syntaxHighlighting = {
          enable = true;
          highlighters = ["main" "brackets" "pattern" "regexp" "line"];
        };

        ## Setting config dir
        ## Path is relative to $HOME, so we can't use `xdg.configHome' here.
        dotDir = ".config/zsh";

        ## History
        history = {
          path = "${config.home-manager.users.ml.xdg.cacheHome}/zsh/zsh_history";
        };

        ## Save completion dump into $XDG_CACHE_HOME
        completionInit = ''
          autoload -U compinit
          compinit -d "${config.home-manager.users.ml.xdg.cacheHome}/.zcompdump"
        '';
      };
    };
  };
}
