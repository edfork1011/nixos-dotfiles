{ pkgs, ... }:

let
  sddmAstronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;

    wayland = {
      enable = true;
      compositor = "kwin";
    };

    theme = "sddm-astronaut-theme";

    extraPackages = [
      sddmAstronaut
      pkgs.kdePackages.qtmultimedia
    ];

    settings = {
      General = {
        Numlock = "on";
        GreeterEnvironment = "QT_SCALE_FACTOR=1.5";
      };

      Wayland = {
        EnableHiDPI = true;
      };
    };
  };

  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = [
    sddmAstronaut
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/sddm/.config 0755 sddm sddm -"
    "f /var/lib/sddm/.config/kcminputrc 0644 sddm sddm - [Keyboard]\\nNumLock=0\\n"
  ];
}
