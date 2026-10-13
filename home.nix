{ config, pkgs, inputs, ... }:

{
  # ---------------------------------------------------------------------------
  # Home Manager
  # ---------------------------------------------------------------------------

  home.username = "edfork";
  home.homeDirectory = "/home/edfork";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # ---------------------------------------------------------------------------
  # Caelestia Shell
  # ---------------------------------------------------------------------------

  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;

    systemd = {
      enable = false;
      target = "graphical-session.target";
      environment = [ ];
    };

    # Caelestia CLI
    cli = {
      enable = true;

      settings = {
        theme.enableGtk = false;
      };
    };

    settings = {
      bar.statusIcons = [
        {
          id = "lockStatus";
          enabled = true;
        }

        {
          id = "network";
          enabled = true;
        }

        {
          id = "bluetooth";
          enabled = true;
        }

        {
          id = "battery";
          enabled = false;
        }
      ];

      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.idle = {
        lockBeforeSleep = false;
        inhibitWhenAudio = false;
        timeouts = [
          {
            timeout = 600;
            idleAction = "lock";
          }
        ];
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Hyprland
  # ---------------------------------------------------------------------------

  wayland.windowManager.hyprland = {
    enable = true;
  
    package = null;
    portalPackage = null;
  
    # 不让 HM 用 settings 自动生成 Lua
    settings = { };
  };
  
  xdg.configFile."hypr/hyprland.lua".source = ./hypr/hyprland.lua;

  home.file."Pictures/Wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  # ---------------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------------

  home.packages = with pkgs; [
    # Terminal
    kitty

    # File manager
    nautilus

    # Clipboard
    wl-clipboard
    cliphist

    # Screenshot
    grim
    slurp
    swappy

    # Audio / media
    pavucontrol
    playerctl

    # Brightness
    brightnessctl

    # Network
    networkmanagerapplet

    # Archive support
    file-roller

    # Useful Wayland tools
    wlr-randr

    # Browser
    firefox

    # 工作
    qupath
    codex
    onlyoffice-desktopeditors
    vscode
    collabora-office
    
    # 生活
    wechat
    qq
  ];

  xdg.desktopEntries.qupath = {
    name = "QuPath";
    genericName = "Digital Pathology Image Analysis";
    comment = "Bioimage analysis and digital pathology";
    icon = "qupath";
    terminal = false;
    categories = [
      "Graphics"
      "Science"
      "Education"
    ];

    exec = "env _JAVA_OPTIONS=-Dglass.gtk.uiScale=1.5 qupath %F";
  };

  # ---------------------------------------------------------------------------
  # Kitty
  # ---------------------------------------------------------------------------

  programs.kitty = {
    enable = true;

    settings = {
      font_size = 11;

      background = "#2f3b46";
      foreground = "#d8dee9";

      background_opacity = "0.82";

      dynamic_background_opacity = true;

      window_padding_width = 8;

      enable_audio_bell = false;

      confirm_os_window_close = 0;
    };
  };

  # ---------------------------------------------------------------------------
  # Git
  # ---------------------------------------------------------------------------
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "edfork1011";
        email = "kynixcn@yahoo.com";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # GTK
  # ---------------------------------------------------------------------------
  gtk = {
    enable = true;

    theme = {
      name = "Orchis-Light";
      package = pkgs.orchis-theme;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "default";
    gtk-theme = "Orchis-Light";
    icon-theme = "Papirus";
  };
  
}
