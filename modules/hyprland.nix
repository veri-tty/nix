{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland = {
      enable = lib.mkEnableOption {
        description = "Enable Hyprland";
        default = false;
      };
    };
    wallpaper = lib.mkOption {
      type = lib.types.str;
      description = "Path to wallpaper";
      default = "/home/ml/Pictures/wallpaper.jpg";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.hyprland.enable {
      environment.systemPackages = [
        pkgs.waybar
        pkgs.hyprpaper
        pkgs.libva
        pkgs.nvidia-vaapi-driver
        pkgs.hyprshot
        pkgs.nerd-fonts.sauce-code-pro
        pkgs.wofi
      ];

      programs.hyprland.enable = true;

      home-manager.users.ml = {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = true;
          extraConfig = ''
            env = LIBVA_DRIVER_NAME,direct
            env = XDG_SESSION_TYPE,wayland
            env = GBM_BACKEND,nvidia-drm
            env = __GLX_VENDOR_LIBRARY_NAME,nvidia
            env = WLR_NO_HARDWARE_CURSORS,1
            cursor {
              no_hardware_cursors = true
            }
            ################
            ### MONITORS ###
            ################

            # See https://wiki.hyprland.org/Configuring/Monitors/
            monitor = DP-1, 2560x1440@144, 0x0, 1.3
            xwayland {
              force_zero_scaling = true
            }

            ###################
            ##  STARTUP ONCE ##
            ###################

            exec-once = polkit-agent-helper-1
            exec-once = systemctl start --user polkit-gnome-authentication-agent-1

            ###################
            ### MY PROGRAMS ###
            ###################

            # See https://wiki.hyprland.org/Configuring/Keywords/

            # Set programs that you use
            $terminal = kitty
            $browser = floorp
            $menu = rofi --show drun

            #############################
            ### ENVIRONMENT VARIABLES ###
            #############################

            # See https://wiki.hyprland.org/Configuring/Environment-variables/

            env = XCURSOR_SIZE,24
            env = HYPRCURSOR_SIZE,24


            #####################
            ### LOOK AND FEEL ###
            #####################

            # Refer to https://wiki.hyprland.org/Configuring/Variables/

            # https://wiki.hyprland.org/Configuring/Variables/#general
            general {
                gaps_in = 5
                gaps_out = 10

                border_size = 2

                # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
                col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
                col.inactive_border = rgba(595959aa)

                # Set to true enable resizing windows by clicking and dragging on borders and gaps
                resize_on_border = false

                # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
                allow_tearing = false

                layout = dwindle
            }

            # https://wiki.hyprland.org/Configuring/Variables/#decoration
            decoration {
                rounding = 0

                # Change transparency of focused and unfocused windows
                active_opacity = 1.0
                inactive_opacity = 1.0


                # https://wiki.hyprland.org/Configuring/Variables/#blur
                blur {
                    enabled = true
                    size = 3
                    passes = 1

                    vibrancy = 0.1696
                }
            }

            # https://wiki.hyprland.org/Configuring/Variables/#animations
            animations {
                enabled = no #, please :)

                # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

                bezier = easeOutQuint,0.23,1,0.32,1
                bezier = easeInOutCubic,0.65,0.05,0.36,1
                bezier = linear,0,0,1,1
                bezier = almostLinear,0.5,0.5,0.75,1.0
                bezier = quick,0.15,0,0.1,1

                animation = global, 1, 10, default
                animation = border, 1, 5.39, easeOutQuint
                animation = windows, 1, 4.79, easeOutQuint
                animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
                animation = windowsOut, 1, 1.49, linear, popin 87%
                animation = fadeIn, 1, 1.73, almostLinear
                animation = fadeOut, 1, 1.46, almostLinear
                animation = fade, 1, 3.03, quick
                animation = layers, 1, 3.81, easeOutQuint
                animation = layersIn, 1, 4, easeOutQuint, fade
                animation = layersOut, 1, 1.5, linear, fade
                animation = fadeLayersIn, 1, 1.79, almostLinear
                animation = fadeLayersOut, 1, 1.39, almostLinear
                animation = workspaces, 1, 1.94, almostLinear, fade
                animation = workspacesIn, 1, 1.21, almostLinear, fade
                animation = workspacesOut, 1, 1.94, almostLinear, fade
            }

            # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
            # "Smart gaps" / "No gaps when only"
            # uncomment all if you wish to use that.
            # workspace = w[t1], gapsout:0, gapsin:0
            # workspace = w[tg1], gapsout:0, gapsin:0
            # workspace = f[1], gapsout:0, gapsin:0
            # windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
            # windowrulev2 = rounding 0, floating:0, onworkspace:w[t1]
            # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tg1]
            # windowrulev2 = rounding 0, floating:0, onworkspace:w[tg1]
            # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
            # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            dwindle {
                pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                preserve_split = true # You probably want this
            }

            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            master {
                new_status = master
            }

            # https://wiki.hyprland.org/Configuring/Variables/#misc
            misc {
                force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
                disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
            }


            #############
            ### INPUT ###
            #############

            # https://wiki.hyprland.org/Configuring/Variables/#input
            input {
                kb_layout = de
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =

                follow_mouse = 1

                sensitivity = 0.4 # -1.0 - 1.0, 0 means no modification.

                touchpad {
                    natural_scroll = true
                    disable_while_typing = yes
                }
            }

            # https://wiki.hyprland.org/Configuring/Variables/#gestures
            gestures {
                workspace_swipe = false
            }

            # Example per-device config
            # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
            device {
                name = epic-mouse-v1
                sensitivity = -0.5
            }


            ###################
            ### KEYBINDINGS ###
            ###################

            # See https://wiki.hyprland.org/Configuring/Keywords/
            $mainMod = SUPER # Sets "Windows" key as main modifier

            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            bind = $mainMod, Return, exec, alacritty
            bind = $mainMod, Space, exec, wofi --show drun
            bind = $mainMod, Q, killactive,
            bind = $mainMod, M, exit,
            bind = $mainMod, L, exec, hyprlock
            bind = $mainMod, W, exec, floorp
            bind = $mainMod, C, exec, code --enable-features=UseOzonePlatform --ozone-platform=wayland
            bind = $mainMod, V, togglefloating,
            bind = $mainMod, R, exec, $menu
            bind = $mainMod, P, pseudo, # dwindle
            bind = $mainMod, J, togglesplit, # dwindle

            # Move focus with mainMod + arrow keys
            bind = $mainMod, left, movefocus, l
            bind = $mainMod, right, movefocus, r
            bind = $mainMod, up, movefocus, u
            bind = $mainMod, down, movefocus, d

            # Switch workspaces with mainMod + [0-9]
            bind = $mainMod, 1, workspace, 1
            bind = $mainMod, 2, workspace, 2
            bind = $mainMod, 3, workspace, 3
            bind = $mainMod, 4, workspace, 4
            bind = $mainMod, 5, workspace, 5
            bind = $mainMod, 6, workspace, 6
            bind = $mainMod, 7, workspace, 7
            bind = $mainMod, 8, workspace, 8
            bind = $mainMod, 9, workspace, 9
            bind = $mainMod, 0, workspace, 10

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            bind = $mainMod SHIFT, 1, movetoworkspace, 1
            bind = $mainMod SHIFT, 2, movetoworkspace, 2
            bind = $mainMod SHIFT, 3, movetoworkspace, 3
            bind = $mainMod SHIFT, 4, movetoworkspace, 4
            bind = $mainMod SHIFT, 5, movetoworkspace, 5
            bind = $mainMod SHIFT, 6, movetoworkspace, 6
            bind = $mainMod SHIFT, 7, movetoworkspace, 7
            bind = $mainMod SHIFT, 8, movetoworkspace, 8
            bind = $mainMod SHIFT, 9, movetoworkspace, 9
            bind = $mainMod SHIFT, 0, movetoworkspace, 10

            # Example special workspace (scratchpad)
            bind = $mainMod, S, togglespecialworkspace, magic
            bind = $mainMod SHIFT, S, movetoworkspace, special:magic

            # Scroll through existing workspaces with mainMod + scroll
            bind = $mainMod, mouse_down, workspace, e+1
            bind = $mainMod, mouse_up, workspace, e-1

            # Move/resize windows with mainMod + LMB/RMB and dragging
            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow

            # Laptop multimedia keys for volume and LCD brightness
            bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
            bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
            bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

            # Requires playerctl
            bindl = , XF86AudioNext, exec, playerctl next
            bindl = , XF86AudioPause, exec, playerctl play-pause
            bindl = , XF86AudioPlay, exec, playerctl play-pause
            bindl = , XF86AudioPrev, exec, playerctl previous

            ##############################
            ### WINDOWS AND WORKSPACES ###
            ##############################

            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

            # Example windowrule v1
            # windowrule = float, ^(kitty)$

            # Example windowrule v2
            # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

            # Ignore maximize requests from apps. You'll probably like this.
            windowrulev2 = suppressevent maximize, class:.*

            # Fix some dragging issues with XWayland
            windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
          '';
        };

        programs.hyprlock = {
          enable = true;
          extraConfig = ''
            # $text_color = rgba(E3E1EFFF)
            # $entry_background_color = rgba(12131C11)
            # $entry_border_color = rgba(908F9F55)
            # $entry_color = rgba(C6C5D6FF)
            $text_color = rgba(FFFFFFFF)
            $entry_background_color = rgba(33333311)
            $entry_border_color = rgba(3B3B3B55)
            $entry_color = rgba(FFFFFFFF)
            $font_family = Rubik Light
            $font_family_clock = Rubik Light
            $font_material_symbols = Material Symbols Rounded

            background {
                # color = rgba(0D0D17FF)
                color = rgba(000000FF)
                # path = {{ SWWW_WALL }}
                # path = screenshot
                # blur_size = 5
                # blur_passes = 4
            }
            input-field {
                monitor =
                size = 250, 50
                outline_thickness = 2
                dots_size = 0.1
                dots_spacing = 0.3
                outer_color = $entry_border_color
                inner_color = $entry_background_color
                font_color = $entry_color
                # fade_on_empty = true

                position = 0, 20
                halign = center
                valign = center
            }

            label { # Clock
                monitor =
                text = $TIME
                shadow_passes = 1
                shadow_boost = 0.5
                color = $text_color
                font_size = 65
                font_family = $font_family_clock

                position = 0, 300
                halign = center
                valign = center
            }
            label { # Greeting
                monitor =
                text = hi $USER !!!
                shadow_passes = 1
                shadow_boost = 0.5
                color = $text_color
                font_size = 20
                font_family = $font_family

                position = 0, 240
                halign = center
                valign = center
            }
            label { # lock icon
                monitor =
                text = lock
                shadow_passes = 1
                shadow_boost = 0.5
                color = $text_color
                font_size = 21
                font_family = $font_material_symbols

                position = 0, 65
                halign = center
                valign = bottom
            }
            label { # ' locked ' text
                monitor =
                text = locked
                shadow_passes = 1
                shadow_boost = 0.5
                color = $text_color
                font_size = 14
                font_family = $font_family

                position = 0, 45
                halign = center
                valign = bottom
            }

            label { # Status
                monitor =
                text = cmd[update:5000] ~/.config/hypr/hyprlock/status.sh
                shadow_passes = 1
                shadow_boost = 0.5
                color = $text_color
                font_size = 14
                font_family = $font_family

                position = 30, -30
                halign = left
                valign = top
            }
          '';
        };

        services.hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;
            preload = ["${config.wallpaper}"];
            wallpaper = [
              "DP-1,${config.wallpaper}"
            ];
          };
        };

        programs.wofi = {
          enable = true;
          style = ''
            /**
             * Rofi Theme
             * Author: machaerus (https://gitlab.com/machaerus/dotfiles)
             */

            * {
               maincolor:        #b58900;
               highlight:        bold #d69f00;
               urgentcolor:      #859900;
               fgwhite:          #fdf6e3;
               blackdarkest:     #002b36;
               blackwidget:      #002b36;
               blackentry:       #002b36;
               blackselect:      #065069;
               darkgray:         #002b36;
               scrollbarcolor:   #eee8d5;
               font: "Roboto Mono 11";
               background-color: @blackdarkest;
               margin: 0px 0px 0px 0px;
               padding: 0px 0px 0px 0px;
               border: 0px 0px 0px 0px;
               spacing: 0px;
            }

            window {
               background-color: @blackdarkest;
               border: 3px;
               padding: 0px 0px 0px 0px;
               margin: 0px 0px 0px 0px;
               border-color: @maincolor;
               anchor: north;
               location: north;
               y-offset: 15%;
            }

            mainbox {
               background-color: @blackdarkest;
               spacing:0px;
               children: [inputbar, listview];
            }

            message {
               padding: 0px 0px;
               background-color:@blackwidget;
            }

            listview {
               fixed-height: false;
               dynamic: true;
               scrollbar: false;
               spacing: 0px;
               padding: 0px 0px 0px 0px;
               margin: 0px 0px 0px 0px;
               background: @blackdarkest;
            }

            element {
               padding: 5px 12px;
            }

            element normal.normal {
               padding: 0px 0px;
               background-color: @blackentry;
               text-color: @fgwhite;
            }

            element normal.urgent {
               background-color: @blackentry;
               text-color: @urgentcolor;
            }

            element normal.active {
               background-color: @blackentry;
               text-color: @maincolor;
            }

            element selected.normal {
                background-color: @blackselect;
                text-color:       @fgwhite;
            }

            element selected.urgent {
                background-color: @urgentcolor;
                text-color:       @blackdarkest;
            }

            element selected.active {
                background-color: @maincolor;
                text-color:       @blackdarkest;
            }

            element alternate.normal {
                background-color: @blackentry;
                text-color:       @fgwhite;
            }

            element alternate.urgent {
                background-color: @blackentry;
                text-color:       @urgentcolor;
            }

            element alternate.active {
                background-color: @blackentry;
                text-color:       @maincolor;
            }

            scrollbar {
               background-color: @blackwidget;
               handle-color: @darkgray;
               handle-width: 15px;
            }

            mode-switcher {
               background-color: @blackwidget;
            }

            button {
               background-color: @blackwidget;
               text-color:       @darkgray;
            }

            button selected {
                text-color:       @maincolor;
            }

            inputbar {
               children: [ textbox-prompt-colon, entry ];
               background-color: @blackdarkest;
               spacing: 0px;
            }

            prompt {
               enabled: true;
               padding: 7px 12px 6px 7px;
               /* background-color: @maincolor;*/
               text-color: @maincolor;
            }

            textbox {
               text-color: @darkgray;
               background-color: @blackwidget;
            }

            textbox-prompt-colon {
               padding: 8px 4px 7px 10px;
               /* background-color: @maincolor;*/
               text-color: @maincolor;
               expand: false;
               str: "";
               font: "feather 14";
            }

            entry {
               padding: 7px 10px;
               background-color: @blackwidget;
               text-color: @fgwhite;
            }

            case-indicator {
               padding: 6px 10px;
               text-color: @maincolor;
               background-color: @blackwidget;
            }
          '';
        };
      };
    })
  ];
}
