{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Hyprland-related packages
  home.packages = with pkgs; [
    hyprpaper  # Wallpaper manager for Hyprland
    hyprshot   # Screenshot tool for Hyprland
  ];
  
  # Hyprpaper service configuration
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["/home/ml/pics/wall/wallhaven-jx632y.jpg"];
      wallpaper = [
        "DP-1,/home/ml/pics/wall/wallhaven-jx632y.jpg"
      ];
    };
  };
  
  # Hyprlock screen locker configuration
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      general {
          grace = 1
      }

      background {
          monitor = DP-2
      	#path = screenshot   # screenshot of your desktop
      	path = $HOME/.config/hypr/wallpaper_effects/.wallpaper_modified   # NOTE only png supported for now
          #color = $color7

          # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
          blur_size = 5
          blur_passes = 1 # 0 disables blurring
          noise = 0.0117
          contrast = 1.3000 # Vibrant!!!
          brightness = 0.8000
          vibrancy = 0.2100
          vibrancy_darkness = 0.0
      }

      input-field {
          monitor =
          size = 250, 50
          outline_thickness = 3
          dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          outer_color = $color5
          inner_color = $color0
          font_color = $color12
          #fade_on_empty = true
          placeholder_text = <i>Password...</i> # Text rendered in the input box when it's empty.
          hide_input = false

          position = 0, 200
          halign = center
          valign = bottom
      }

      # Date
      label {
          monitor =
          text = cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"
          color = $color12
          font_size = 34
          font_family = JetBrains Mono Nerd Font 10

          position = 0, -150
          halign = center
          valign = top
      }

      # Week
      label {
          monitor =
          text = cmd[update:18000000] echo "<b> "$(date +'Week %U')" </b>"
          color = $color5
          font_size = 24
          font_family = JetBrains Mono Nerd Font 10
          position = 0, -250
          halign = center
          valign = top
      }

      # Time
      label {
          monitor =
          #text = cmd[update:1000] echo "<b><big> $(date +"%I:%M:%S %p") </big></b>" # AM/PM
          text = cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>" # 24H
          color = $color15
          font_size = 94
          font_family = JetBrains Mono Nerd Font 10

          position = 0, 0
          halign = center
          valign = center
      }

      # User
      label {
          monitor =
          text =    $USER
          color = $color12
          font_size = 18
          font_family = Inter Display Medium

          position = 0, 100
          halign = center
          valign = bottom
      }

      # uptime
      label {
          monitor =
          text = cmd[update:60000] echo "<b> "$(uptime -p || $Scripts/UptimeNixOS.sh)" </b>"
          color = $color12
          font_size = 24
          font_family = JetBrains Mono Nerd Font 10
          position = 0, 0
          halign = right
          valign = bottom
      }

      # weather edit specific location. Note, this cause a 2-4 seconds delay in locking
      label {
          monitor =
          text = cmd[update:3600000] [ -f ~/.cache/.weather_cache ] && cat  ~/.cache/.weather_cache
          color = $color12
          font_size = 24
          font_family = JetBrains Mono Nerd Font 10
          position = 50, 0
          halign = left
          valign = bottom
      }

      # Put a picture of choice here. Default is the current wallpaper
      image {
          monitor =
          path = $HOME/.config/hypr/wallpaper_effects/.wallpaper_current
          size = 230
          rounding = -1
          border_size = 2
          border_color = $color11
          rotate = 0
          reload_time = -1
          position = 0, 300
          halign = center
          valign = bottom
      }
    '';
  };

  # Hyprland window manager configuration
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # Monitor configuration
      monitor=DP-2,2560x1440@120, 0x0, 1

      # Default applications
      $terminal = alacritty
      $menu = wofi --show drun

      # Startup applications
      exec-once = hyprpaper --config /home/ml/.config/hypr/hyprpaper.conf

      # Environment variables
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24

      # General UI configuration
      general {
          gaps_in = 5
          gaps_out = 20

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

      # Window decoration settings
      decoration {
          rounding = 10

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }

      # Animation settings
      animations {
          enabled = yes, please :)

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

      # Workspace rules
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrule = bordersize 0, floating:0, onworkspace:f[1]
      # windowrule = rounding 0, floating:0, onworkspace:f[1]

      # Layout settings
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      master {
          new_status = master
      }

      # Miscellaneous settings
      misc {
          force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
      }

      # Input configuration
      input {
          kb_layout = de
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = true
          }
      }

      # Gesture configuration
      gestures {
          workspace_swipe = false
      }

      # Per-device configuration
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      # Keybindings
      $mainMod = SUPER # Sets "Windows" key as main modifier

      # Application shortcuts
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, W, exec, floorp
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, L, exec, hyprlock
      bind = $mainMod, C, exec, code

      # Window navigation
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Workspace navigation
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

      # Move windows to workspaces
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

      # Special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Mouse navigation
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Window manipulation with mouse
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Media keys
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

      # Media player controls
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      # Window rules
      windowrule = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
  };
}