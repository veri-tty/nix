{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bspwm;
in {
  options.services.bspwm = {
    enable = mkEnableOption "bspwm window manager";

    package = mkOption {
      type = types.package;
      default = pkgs.bspwm;
      defaultText = "pkgs.bspwm";
      description = "The bspwm package to use.";
    };

    sxhkd = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable sxhkd for keyboard shortcuts";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.sxhkd;
        defaultText = "pkgs.sxhkd";
        description = "The sxhkd package to use.";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to sxhkdrc file. If null, the default configuration will be used.";
      };
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to bspwmrc file. If null, the default configuration will be used.";
    };

    monitors = mkOption {
      type = types.listOf (types.listOf types.str);
      default = [ [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ] ];
      description = "Monitor and desktop configuration. Each inner list represents a monitor, with each string representing a desktop name.";
      example = literalExpression ''
        [
          [ "1" "2" "3" "4" "5" ]  # First monitor
          [ "6" "7" "8" "9" "10" ] # Second monitor
        ]
      '';
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Set of bspwm configuration options.";
      example = literalExpression ''
        {
          border_width = 2;
          window_gap = 10;
          split_ratio = 0.52;
          borderless_monocle = true;
          gapless_monocle = true;
          focus_follows_pointer = true;
        }
      '';
    };

    rules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of window rules to apply.";
      example = literalExpression ''
        [
          "firefox:*:* desktop=^2 state=tiled"
          "Gimp:*:* state=floating"
          "Spotify:*:* desktop=^5"
        ]
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional shell commands to run in bspwmrc.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      (mkIf cfg.sxhkd.enable cfg.sxhkd.package)
      feh
      picom
      polybar
      rofi
      alacritty
      dunst
      xorg.xbacklight
    ];

    services.xserver.enable = true;
    services.xserver.windowManager.bspwm = {
      enable = true;
      package = cfg.package;
    };

    # Let NixOS handle the session file properly
    services.xserver.windowManager.session = lib.singleton {
      name = "bspwm";
      start = ''
        ${cfg.package}/bin/bspwm &
        waitPID=$!
      '';
    };

    # Use the common display manager configuration
    services.displayManager.setup.enable = true;

    environment.etc = let
      defaultBspwmrc = pkgs.writeShellScript "bspwmrc" ''
        #!/bin/sh

        # Autostart
        ${optionalString cfg.sxhkd.enable ''
          pgrep -x sxhkd > /dev/null || sxhkd ${optionalString (cfg.sxhkd.configFile != null)
          "-c ${cfg.sxhkd.configFile}"} &
        ''}
        pkill picom
        picom --experimental-backends &

        # Set up monitors and desktops
        ${concatMapStringsSep "\n" (desktops: ''
          bspc monitor ${optionalString (length cfg.monitors > 1)
          "$MONITOR"} -d ${concatStringsSep " " desktops}
        '') cfg.monitors}

        # Apply settings
        ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
          bspc config ${name} ${toString value}
        '') cfg.settings)}

        # Set default values if not specified
        ${optionalString (!hasAttr "border_width" cfg.settings) ''
          bspc config border_width 0
        ''}
        ${optionalString (!hasAttr "window_gap" cfg.settings) ''
          bspc config window_gap 9
        ''}
        ${optionalString (!hasAttr "focus_follows_pointer" cfg.settings) ''
          bspc config focus_follows_pointer true
        ''}
        ${optionalString (!hasAttr "pointer_follows_monitor" cfg.settings) ''
          bspc config pointer_follows_monitor true
        ''}
        ${optionalString (!hasAttr "split_ratio" cfg.settings) ''
          bspc config split_ratio 0.52
        ''}
        ${optionalString (!hasAttr "borderless_monocle" cfg.settings) ''
          bspc config borderless_monocle true
        ''}
        ${optionalString (!hasAttr "gapless_monocle" cfg.settings) ''
          bspc config gapless_monocle true
        ''}

        # Apply rules
        ${concatMapStringsSep "\n" (rule: ''
          bspc rule -a ${rule}
        '') cfg.rules}

        # Run polybar
        ~/.config/polybar/launch.sh &

        # Set wallpaper
        feh --bg-fill ~/Pictures/wall/1.jpg &

        # Run extra configuration
        ${cfg.extraConfig}
      '';

      defaultSxhkdrc = pkgs.writeText "sxhkdrc" ''
        #
        # wm independent hotkeys
        #

        # terminal emulator
        super + Return
          ${pkgs.alacritty}/bin/alacritty

        # program launcher
        super + @space
          ${pkgs.rofi}/bin/rofi -show drun -theme onedark

        # make sxhkd reload its configuration files:
        super + Escape
          pkill -USR1 -x sxhkd

        #
        # bspwm hotkeys
        #

        # quit/restart bspwm
        super + alt + {q,r}
          bspc {quit,wm -r}

        # close and kill
        super + {_,shift + }w
          bspc node -{c,k}

        # alternate between the tiled and monocle layout
        super + m
          bspc desktop -l next

        # send the newest marked node to the newest preselected node
        super + y
          bspc node newest.marked.local -n newest.!automatic.local

        # swap the current node and the biggest window
        super + g
          bspc node -s biggest.window

        #
        # state/flags
        #

        # set the window state
        super + {t,shift + t,s,f}
          bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

        # set the node flags
        super + ctrl + {m,x,y,z}
          bspc node -g {marked,locked,sticky,private}

        #
        # focus/swap
        #

        # focus the node in the given direction
        super + {_,shift + }{h,j,k,l}
          bspc node -{f,s} {west,south,north,east}

        # focus the node for the given path jump
        super + {p,b,comma,period}
          bspc node -f @{parent,brother,first,second}

        # focus the next/previous window in the current desktop
        super + {_,shift + }c
          bspc node -f {next,prev}.local.!hidden.window

        # focus the next/previous desktop in the current monitor
        super + bracket{left,right}
          bspc desktop -f {prev,next}.local

        # focus the last node/desktop
        super + {grave,Tab}
          bspc {node,desktop} -f last

        # focus the older or newer node in the focus history
        super + {o,i}
          bspc wm -h off; \
          bspc node {older,newer} -f; \
          bspc wm -h on

        # focus or send to the given desktop
        super + {_,shift + }{1-9,0}
          bspc {desktop -f,node -d} '^{1-9,10}'

        #
        # preselect
        #

        # preselect the direction
        super + ctrl + {h,j,k,l}
          bspc node -p {west,south,north,east}

        # preselect the ratio
        super + ctrl + {1-9}
          bspc node -o 0.{1-9}

        # cancel the preselection for the focused node
        super + ctrl + space
          bspc node -p cancel

        # cancel the preselection for the focused desktop
        super + ctrl + shift + space
          bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

        #
        # move/resize
        #

        # expand a window by moving one of its side outward
        super + alt + {h,j,k,l}
          bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

        # contract a window by moving one of its side inward
        super + alt + shift + {h,j,k,l}
          bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

        # move a floating window
        super + {Left,Down,Up,Right}
          bspc node -v {-20 0,0 20,0 -20,20 0}
      '';
    in {
      "bspwm/bspwmrc" = {
        source = if cfg.configFile != null then cfg.configFile else defaultBspwmrc;
        mode = "0755";
      };

      "sxhkd/sxhkdrc" = mkIf cfg.sxhkd.enable {
        source = if cfg.sxhkd.configFile != null then cfg.sxhkd.configFile else defaultSxhkdrc;
      };
    };

    # Ensure xdg configuration directory exists
    system.activationScripts.bspwm = ''
      mkdir -p /etc/bspwm
      mkdir -p /etc/sxhkd
    '';
  };
}