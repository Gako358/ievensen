{ lib
, pkgs
, inputs
, osConfig
, ...
}:
{
  imports = [
    ./binds.nix
    ./hyprland.nix
    ./rules.nix
    ./systemd-fixes.nix
    ./tty.nix
  ];

  config = lib.mkIf (osConfig.environment.desktop.windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
        # hyprbars
        # hyprexpo
      ];
      systemd = {
        enable = true;
        variables = [ "--all" ];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

      settings = {
        cursor.inactive_timeout = 5;
      };
    };

    home = {
      packages = [
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        pkgs.arandr # screen layout manager
        pkgs.bottom # alternative to htop & ytop
        pkgs.ffmpegthumbnailer # thumbnailer for video files
        pkgs.glib # Core application building blocks library (used by GTK/GNOME apps)
        pkgs.gnome-calendar # Calendar application from the GNOME desktop
        pkgs.gnome-boxes # Simple virtual machine manager from GNOME
        pkgs.gnome-weather # Weather application from the GNOME desktop
        pkgs.gnome-system-monitor # System resource monitor from GNOME
        pkgs.headsetcontrol # control logitech headsets
        pkgs.imagemagick # image manipulation
        pkgs.paprefs # pulseaudio preferences
        pkgs.pavucontrol # pulseaudio volume control
        pkgs.poppler # pdf tools
        pkgs.pulsemixer # pulseaudio volume control
        pkgs.ranger # file manager
        pkgs.scrot # screenshot tool
        pkgs.slurp # select a region in a wayland compositor
        pkgs.wayshot # screenshot tool
        pkgs.wgetpaste # paste to pastebin
        pkgs.wl-clipboard # wayland clipboard manager
        pkgs.wl-gammactl # wayland gamma control
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = 1;
        SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
        DIRENV_LOG_FORMAT = "";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
        QT_QPA_PLATFORMTHEME = "qt5ct";
      };
    };

    # Fake a tray, so apps can start
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };
}
