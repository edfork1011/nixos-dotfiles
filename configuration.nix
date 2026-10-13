{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sddm.nix
  ];

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;
  };

  # 保留一些 generations
  boot.loader.systemd-boot.configurationLimit = 10;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking.hostName = "EDFORK-NIXOS";

  networking.networkmanager.enable = true;

  # ---------------------------------------------------------------------------
  # Nix
  # ---------------------------------------------------------------------------

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  # 每周自动清理旧 store
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # nixpkgs overlay
  nixpkgs.overlays = [
    (final: prev: {
      qupath = final.callPackage ./pkgs/qupath/package.nix { };
    })
  ];

  environment.shellAliases = {
    nupdate = "sudo nixos-rebuild switch --flake /etc/nixos#nix-pc";
    ngc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    ngenerations = "sudo nixos-rebuild list-generations";
    ntest = "sudo nixos-rebuild test --flake /etc/nixos#nix-pc";
    nboot = "sudo nixos-rebuild boot --flake /etc/nixos#nix-pc";
    ncheck = "nix flake check /etc/nixos";
    nflakeup = "sudo nix flake update --flake /etc/nixos";
    nrollback = "sudo nixos-rebuild switch --rollback";
    nixdir = "cd /etc/nixos";
  };

  # ---------------------------------------------------------------------------
  # Locale / timezone
  # ---------------------------------------------------------------------------

  time.timeZone = "Asia/Taipei";

  i18n.defaultLocale = "zh_TW.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "zh_TW.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "zh_TW.UTF-8";
    LC_TIME = "zh_TW.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  
    fcitx5 = {
      waylandFrontend = true;
  
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
      ];
  
      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = true;
            resetStateWhenFocusIn = "No";
            ShareInputState = "Program";
          };
        };
  
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
  
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
  
          "Groups/0/Items/1" = {
            Name = "rime";
            Layout = "";
          };
  
          GroupOrder = {
            "0" = "Default";
          };
        };
      };
    };
  };

  # ---------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------

  users.users.edfork = {
    isNormalUser = true;

    description = "edfork";

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];

    shell = pkgs.bash;
  };

  # sudo
  security.sudo.enable = true;

  # ---------------------------------------------------------------------------
  # Hyprland
  # ---------------------------------------------------------------------------

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 不安装 SDDM / GDM / greetd
  #
  # 开机：
  #
  #   tty -> 登录 -> Hyprland
  #
  # 正好符合你以前喜欢的方式。

  # ---------------------------------------------------------------------------
  # XDG portals
  # ---------------------------------------------------------------------------

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # ---------------------------------------------------------------------------
  # OpenSSH
  # ---------------------------------------------------------------------------
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  # ---------------------------------------------------------------------------
  # DBus / Polkit / storage
  # ---------------------------------------------------------------------------

  services.dbus.enable = true;

  security.polkit.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;

  # ---------------------------------------------------------------------------
  # Audio
  # ---------------------------------------------------------------------------

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Bluetooth
  # ---------------------------------------------------------------------------

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # ---------------------------------------------------------------------------
  # Fonts
  # ---------------------------------------------------------------------------

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      liberation_ttf

      material-symbols
      rubik

      nerd-fonts.caskaydia-cove
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];

        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];

        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Basic system packages
  # ---------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl

    pciutils
    usbutils

    unzip
    zip

    tree
    file

    htop
    btop

    ripgrep
    fd

    jq

    # Wayland debugging
    wayland-utils
  ];

  # Electron / Chromium 优先 Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  # ---------------------------------------------------------------------------
  # Firmware
  # ---------------------------------------------------------------------------

  hardware.enableRedistributableFirmware = true;

  # ---------------------------------------------------------------------------
  # FKU NVIDIA
  # ---------------------------------------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ---------------------------------------------------------------------------
  # stateVersion
  # ---------------------------------------------------------------------------

  system.stateVersion = "26.05";
}
