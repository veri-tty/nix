{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland";
    };
    wallpaper = lib.mkOption {
      type = lib.types.str;
      description = "Path to wallpaper";
      default = "/home/ml/Pictures/wallpaper.jpg";
    };
    display = lib.mkOption {
      type = lib.types.str;
      description = "Display Name";
      default = "DP-1";
    };
  };

  config = lib.mkIf config.hyprland.enable {
    environment.systemPackages = [
      pkgs.waybar
      pkgs.hyprpaper
      pkgs.libva
      pkgs.nvidia-vaapi-driver
      pkgs.hyprshot
      pkgs.wofi
      pkgs.playerctl
      pkgs.wireplumber
      pkgs.brightnessctl
      pkgs.nerd-fonts.hack
      pkgs.font-awesome
    ];

    programs.hyprland.enable = true;

    # Enable display manager to auto-start Hyprland
    services.displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        settings.Autologin = {
          Session = "hyprland";
          User = "ml";
        };
      };
    };
    services.displayManager.sddm.wayland.enable = true;

    home-manager.users.ml = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
      };

      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            spacing = 4;
            modules-left = ["hyprland/workspaces"];
            modules-center = ["clock"];
            modules-right = ["pulseaudio" "mpris" "tray"];

            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "urgent" = "";
                "active" = "";
                "default" = "";
              };
              on-click = "activate";
              sort-by-number = true;
            };

            "clock" = {
              format = "{:%H:%M - %d/%m/%Y}";
              tooltip = true;
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };

            "mpris" = {
              format = "{player_icon} {artist} - {title}";
              format-paused = "{status_icon} {artist} - {title}";
              player-icons = {
                "default" = "▶";
                "spotify" = "󰓇";
              };
              status-icons = {
                "paused" = "⏸";
              };
              max-length = 40;
              on-click = "playerctl play-pause";
              on-scroll-up = "playerctl next";
              on-scroll-down = "playerctl previous";
            };

            "pulseaudio" = {
              format = "{volume}% {icon}";
              format-muted = "󰝟";
              format-icons = {
                "default" = ["󰕿" "󰖀" "󰕾"];
              };
              on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              scroll-step = 5.0;
            };

            "tray" = {
              spacing = 10;
            };
          };
        };
        style = ''
          * {
            font-family: "SauceCodePro Nerd Font";
            font-size: 13px;
          }

          window#waybar {
            background-color: rgba(30, 30, 46, 0.9);
            color: #cdd6f4;
            transition-property: background-color;
            transition-duration: .5s;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #cdd6f4;
            border-radius: 0;
          }

          #workspaces button.active {
            background: rgba(137, 180, 250, 0.2);
            color: #89b4fa;
          }

          #clock, #pulseaudio, #mpris, #tray {
            padding: 0 10px;
            border-radius: 3px;
            background-color: rgba(49, 50, 68, 0.6);
            color: #cdd6f4;
            margin: 5px 0;
          }

          #mpris {
            color: #a6e3a1;
          }

          #pulseaudio {
            color: #f9e2af;
          }

          #clock {
            color: #89b4fa;
          }
        '';
      };

      wayland.windowManager.hyprland = {
        extraConfig = ''
          # Environment variables
          env = LIBVA_DRIVER_NAME,direct
          env = XDG_SESSION_TYPE,wayland
          env = GBM_BACKEND,nvidia-drm
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia
          env = WLR_NO_HARDWARE_CURSORS,1

          # Cursor settings
          cursor {
            no_hardware_cursors = true
          }

          ################
          ### MONITORS ###
          ################

          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = DP-1, 2560x1440@144, 0x0, 1.333333
          xwayland {
            force_zero_scaling = true
          }

          ###################
          ##  STARTUP ONCE ##
          ###################


          # Start waybar with a small delay to ensure display is ready
          exec-once = hyprlock

          # Auto-start applications in their assigned workspaces
          exec-once = alacritty
          exec-once = floorp
          exec-once = zedidor
          exec-once = spotify

          ###################
          ### MY PROGRAMS ###
          ###################

          # See https://wiki.hyprland.org/Configuring/Keywords/

          # Set programs that you use
          $terminal = alacritty
          $browser = floorp
          $menu = rofi --show drun

          #############################
          ### ENVIRONMENT VARIABLES ###
          #############################

          # See https://wiki.hyprland.org/Configuring/Environment-variables/

          env = XCURSOR_SIZE,24
          env = HYPRCURSOR_SIZE,24
          env = XCURSOR_THEME,Vanilla-DMZ


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
          bind = $mainMod, Return, exec, $terminal
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

          # Media controls for Spotify and other players
          bindl = , XF86AudioNext, exec, playerctl next
          bindl = , XF86AudioPause, exec, playerctl play-pause
          bindl = , XF86AudioPlay, exec, playerctl play-pause
          bindl = , XF86AudioPrev, exec, playerctl previous
          bindl = , XF86AudioMute, exec, playerctl volume 0
          bind = $mainMod, F1, exec, playerctl play-pause
          bind = $mainMod, F2, exec, playerctl previous
          bind = $mainMod, F3, exec, playerctl next

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

          # Assign applications to specific workspaces
          windowrulev2 = workspace 1,class:^(Alacritty)$
          windowrulev2 = workspace 3,class:^(floorp)$
          windowrulev2 = workspace 2,class:^(zed)$
          windowrulev2 = workspace 4,class:^(Spotify)$,title:^(Spotify)$
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

                      # Full screen background image
                      image {
              monitor =
              path = ${config.wallpaper}
              size = cover
              rounding = 0
              blur_size = 0
              blur_passes = 0
              brightness = 1.0
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
                          text =  $USER :)
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
            "${config.display},${config.wallpaper}"
          ];
        };
      };

      programs.wofi = {
        enable = true;
        style = ''
          window {
            margin: 0px;
            border: 2px solid #89b4fa;
            background-color: #1e1e2e;
            border-radius: 8px;
          }

          #input {
            margin: 5px;
            border: none;
            color: #cdd6f4;
            background-color: #313244;
            border-radius: 8px;
          }

          #inner-box {
            margin: 5px;
            border: none;
            background-color: #1e1e2e;
            border-radius: 8px;
          }

          #outer-box {
            margin: 5px;
            border: none;
            background-color: #1e1e2e;
            border-radius: 8px;
          }

          #scroll {
            margin: 0px;
            border: none;
          }

          #text {
            margin: 5px;
            border: none;
            color: #cdd6f4;
          }

          #entry:selected {
            background-color: #313244;
            border-radius: 8px;
            outline: none;
          }

          #entry:selected #text {
            color: #89b4fa;
          }
        '';
      };
    };
  };
}
