{...}: {
  programs.waybar.settings = {
    mainBar = {
      position = "top";
      layer = "top";
      height = 30;
      spacing = 15;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      modules-left = [
        "custom/launcher"
        "hyprland/workspaces"
        "cpu"
        "memory"
        "temperature"
        "disk"
      ];
      modules-center = ["clock"];
      modules-right = [
        "tray"
        "pulseaudio"
        "custom/fancontrol"
        "power-profiles-daemon"
        "battery"
        "network"
        "custom/hyprsunset"
        "custom/suspend"
        "custom/notification"
        "custom/pomodoro"
        "custom/clipboard"
        "custom/media"
      ];
      clock = {
        timezone = "Asia/Calcutta";
        calendar = {
          format = {
            today = "<span color='#b4befe'><b><u>{}</u></b></span>";
          };
        };
        format = " {:%H:%M}";
        tooltip = "true";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
        format-alt = " {:%d/%m}";
      };
      "hyprland/workspaces" = {
        format = "{icon} {name}";
        format-icons = {
          "active" = "";
          "default" = "";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        on-click = "activate";
      };
      "hyprland/window" = {
        format = "{}";
        separate-outputs = true;
        max-length = 35;
      };
      memory = {
        format = "󰟜 {}%";
        format-alt = "󰟜 {used} GiB"; # 
        interval = 2;
        on-click-right = "ghostty --title=float_ghostty -e btop";
      };
      cpu = {
        format = "  {usage}%";
        format-alt = "  {avg_frequency} GHz";
        interval = 2;
        on-click-right = "ghostty --title=float_ghostty -e btop";
      };
      disk = {
        # path = "/";
        format = "󰋊 {percentage_used}%";
        interval = 60;
        on-click-right = "ghostty --title=float_ghostty -e btop";
      };
      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰀂 ";
        tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰖪 ";
        on-click = "nm-connection-editor";
      };
      tray = {
        icon-size = 15;
        spacing = 15;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "  {volume}%";
        format-icons = {
          default = [" "];
        };
        scroll-step = 5;
        on-click = "pavucontrol";
      };
      "custom/fancontrol" = {
        format = "󰈐 {}";
        exec-if = "which fw-fanctrl";
        exec = "sleep 0.5; fw-fanctrl print current | rg \"Strategy in use: '(.+)'\" -r '$1'";
        exec-on-event = true;
        interval = "once";
        on-click = "cycle-fan-strategy";
        tooltip = true;
        tooltip-format = "Current fan mode: {}";
      };
      power-profiles-daemon = {
        format = "{icon}";
        exec-if = "which powerprofilesctl";
        tooltip-format = ''
          Power profile: {profile}
          Driver: {driver}'';
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };
      battery = {
        format = "{icon} {capacity}%";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
        format-charging = " {capacity}%";
        format-full = " {capacity}%";
        format-warning = " {capacity}%";
        interval = 5;
        states = {
          warning = 20;
        };
        format-time = "{H}h{M}m";
        tooltip = true;
        tooltip-format = "{time}";
      };
      backlight = {
        # "device": "acpi_video1",
        format = "{percent}% {icon}";
        format-icons = [
          ""
          ""
        ];
        # on-scroll-up = "/home/cp264607/.config/hypr/scripts/tools/brightness_ctl.sh up";
        # on-scroll-down = "/home/cp264607/.config/hypr/scripts/tools/brightness_ctl.sh down";
        interval = 1;
      };
      "custom/launcher" = {
        format = "";
        on-click = "fuzzel";
        on-click-right = "wallpaper-picker";
        tooltip = "false";
      };
      "custom/hyprsunset" = {
        format = "󱣖";
        on-click = "hyprctl hyprsunset temperature 3500";
        on-click-right = "hyprctl hyprsunset temperature identity";
        on-scroll-up = "hyprctl hyprsunset temperature +500";
        on-scroll-down = "hyprctl hyprsunset temperature -500";
        # exec = "echo test";
        # exec-on-event = true;
        # exec-if = "pidof hyprsunset";
        # interval = "once";
        tooltip = false;
      };
      "custom/suspend" = {
        exec = "suspend_state";
        on-click = "toggle_suspend";
        return-type = "json";
        interval = 1;
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon} ";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>   ";
          none = "   ";
          dnd-notification = "<span foreground='red'><sup></sup></span>   ";
          dnd-none = "   ";
          inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
          inhibited-none = "   ";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
          dnd-inhibited-none = "   ";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
      "custom/todo" = {
        format = " {}";
        exec = "cat ~/.config/waybar/todo.txt | head -n 1";
        on-click = "kitty -e nvim ~/.config/waybar/todo.txt";
        tooltip = true;
        tooltip-format = ''"$(cat ~/.config/waybar/todo.txt)"'';
        interval = 5;
      };
      "custom/pomodoro" = {
        format = "🍅 {formated_time}";
        exec = "pomodoro-cli status --format '{remaining_time}'";
        on-click = "pomodoro-cli toggle";
        on-click-right = "pomodoro-cli reset";
        tooltip = true;
        tooltip-format = "Pomodoro: {status}";
        interval = 1;
      };
      "custom/clipboard" = {
        format = "";
        on-click = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
        on-click-right = "cliphist wipe";
        tooltip = false;
      };
      "custom/media" = {
        format = "{icon} {title}";
        return-type = "json";
        # exec = ''playerctl -F metadata --format '{{status}} {{artist}} - {{title}}' | sed -E 's/Playing (.*)/{"icon":"", "title":"\1"}/; s/Paused (.*)/{"icon":"", "title":"\1"}/; s/Stopped (.*)/{"icon":"■", "title":""}/''';
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        max-length = 40;
      };
    };
  };
}
