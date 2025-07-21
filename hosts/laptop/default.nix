{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [Keyboard]
      MatchUdevType=keyboard
      MatchName=Framework Laptop 16 Keyboard Module - ANSI Keyboard
      AttrKeyboardIntegration=internal
    '';
  };

  services = {
    thermald.enable = true;
    # cpupower-gui.enable = true;
    power-profiles-daemon.enable = true;

    fprintd.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
  };

  boot = {
    blacklistedKernelModules = ["k10temp"];
    kernelModules = [
      "acpi_call"
      "cros_ec"
      "cros_ec_lpcs"
      "zenpower"
    ];
    kernelParams = [
      "amd_pstate=active"
      "amdgpu.sg_display=0"
      # There seems to be an issue with panel self-refresh (PSR) that
      # causes hangs for users.
      #
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      "amdgpu.dcdebugmask=0x10"

      "microcode.amd_sha_check=off" # microcode from ucodenix couldn't be loaded without this
    ];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
        framework-laptop-kmod
        # zenpower
      ]
      ++ [pkgs.cpupower-gui];
  };

  hardware.sensor.iio.enable = true;
  hardware.keyboard.qmk.enable = true;

  #   services.flatpak.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;

  #   networking.hostName = "laptop"; # Define your hostname.
  #   networking.wireless.enable = true;  # Enables wireless support via
  #   wpa_supplicant.

  # Configure network proxy if necessary
  #   networking.proxy.default = "http://user:password@proxy:port/";
  #   networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #   networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  qt = {
    enable = true;
    platformTheme = "kde"; # use QT settings from Plasma
  };
  #     environment.variables = {
  #       QT_PLATFORM_PLUGIN_PATH =
  #   "${pkgs.qt5.qtbase}/lib/qt-5/plugins/platforms";
  #       QT_QPA_PLATFORMTHEME = "qt5ct";
  #     };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  #graphics
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics = {
    enable = true; # installs 'pkgs.mesa'
    enable32Bit = true; # installs 'pkgs.pkgsi686Linux.mesa'
    # and more!
  };

  hardware.amdgpu = {
    amdvlk.enable = true;
    amdvlk.support32Bit.enable = true;
    opencl.enable = true;
    # and more!
  };
  #   Enable the X11 windowing system.
  #     services.xserver.enable = true;
  #     hardware.graphics.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  #   services.displayManager.defaultSession = “plasma6”;

  #   # --- MODIFIED: Enable Plasma and use SDDM as the Display Manager ---
  services.xserver.displayManager.sddm.enable = true;
  #
  services.desktopManager = {
    # cosmic.enable = true;
    #       plasma6.enable = true; # Added KDE Plasma
  };

  # # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.gnome.gnome-browser-connector.enable = true; # This is fine to

  #   # --- MODIFIED: Added KDE portal for better integration ---
  xdg.portal = {
    enable = true;
    extraPortals = [
      #       pkgs.xdg-desktop-portal-gtk
      #       pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = ["*"];
  };

  # # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ameen = {
    isNormalUser = true;
    description = "ameen";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # programs.niri.enable = true;

  #NUR PACKAGES: You can find all packages using Packages search for NUR or
  # search our nur-combined repository,
  #which contains all nix expressions from all users, via github.
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };

  # then in configuration.nix
  #   environment.systemPackages = with pkgs; [
  #    nur.repos.mic92.hello-nur
  #   ];

  # programs.thefuck.enable = true;

  environment.shells = with pkgs; [zsh];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # General Applications
    jdk
    acpi
    gettext
    intltool
    brightnessctl
    cpupower-gui
    framework-tool
    powertop
    qbittorrent-enhanced
    ayugram-desktop
    whatsie
    nodejs
    vivaldi
    logseq
    albert
    copyq
    fsearch
    sublime
    mpv
    peazip
    obsidian
    anytype
    code-cursor
    vscode
    rar
    yandex-music
    solaar
    epiphany
    discord
    git
    emacs
    catppuccin-kde
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    arc-kde-theme # Example: Arc Dark theme
    gruvbox-kvantum
    gruvbox-plus-icons
    kde-gruvbox
    kdePackages.koi
    kdePackages.kalm
    kdePackages.yakuake
    papirus-icon-theme
    kde-rounded-corners
    krita
    nautilus

    gruvbox-gtk-theme
    nixfmt-rfc-style

    # # Wayland/Sway specific tools (can be kept)
    grim
    slurp
    wl-clipboard
    mako

    # # CLI tools
    # ffmpeg
    # ripgrep
    # fd

    # # COSMIC Packages (Good to keep for the COSMIC session)
    cosmic-session
    cosmic-settings
    cosmic-launcher
    cosmic-notifications
    cosmic-panel

    # --- ADDED: Essential packages for a good KDE Plasma experience ---
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.kate
    kdePackages.xdg-desktop-portal-kde # Added for KDE
    plasma-panel-colorizer
    plasma-panel-spacer-extended
    kdePackages.plasma-pa
    kdePackages.plasmatube
    kdePackages.plasma-sdk
    plasma-theme-switcher
    #     libsForQt5.plasma-sdk
    #     libsForQt5.plasma-nano
    kdePackages.plasma-workspace
    cassette
    # konsave
    # capitaine-cursors-themed
    # plasma-applet-commandoutput
    # kdePackages.packagekit-qt
    # kdePackages.qtstyleplugin-kvantum
    # qt6.qtwebsockets
    # qt6.qtwebengine
    kdePackages.dolphin-plugins
    # kdePackages.qtwayland
    plasmusic-toolbar
    # kdePackages.plasmatube
    # kdePackages.kalk
    # kdePackages.discover
    kdePackages.kdeconnect-kde
    # kdePackages.kpat
    # kdePackages.kcolorchooser
    # kdePackages.kteatime
    # kdePackages.kbounce
    kdePackages.wallpaper-engine-plugin
    kdePackages.sddm-kcm
    # kdePackages.kanagram
    # kdePackages.kcolorscheme

    #       kdePackages.krecorder
    #       kdePackages.kweather
    #       kdePackages.kcharselect
    #       kdePackages.filelight
    #       kdePackages.kcalc
    #       kdePackages.kclock
    #       kdePackages.kholidays
    #       kdePackages.akonadi-calendar
    #       kdePackages.libkdepim
    #       kdePackages.kdepim-addons
    #       kdePackages.kdepim-runtime
    #       kdePackages.kcontacts
    #       libqalculate
    #       qalculate-qt

    #       floorp
    kdePackages.plasma-browser-integration

    #       kdePackages.zanshin
    # kdePackages.korganizer
    #       kdePackages.merkuro
    #       kdePackages.francis

    #       lldb
    # kdePackages.kompare
    # kdePackages.kdevelop
    #       kdePackages.kcachegrind
    #       gcc
    #       gdb
    # clang-tools
    # bash-language-server
    # nixd
    # nixfmt
    # marksman
    # kdePackages.markdownpart
    # lua
    # lua-language-server
    # cppcheck
    nixos-shell

    kdePackages.qtwebengine
    kdePackages.qtlocation
    kdePackages.ksystemstats # needed for the resource widgets
    aspell # needed for spell checking
    aspellDicts.en
    aspellDicts.hu
    kdePackages.qtmultimedia
    kdePackages.karousel
    (
      with pkgs;
        import ./kwin4_effect_geometry_change/kwin4_effect_geometry_change.nix {
          inherit lib;
          inherit stdenv;
          inherit fetchFromGitHub;
          kpackage = kdePackages.kpackage;
          kwin = kdePackages.kwin;
          inherit nodejs;
        }
    )

    #           gimp
    inkscape
    kdePackages.kdenlive

    libreoffice
    pandoc
    texliveFull

    beeper
  ];

  services.udev.packages = with pkgs; [
    solaar
  ];

  # Enable GNOME Keyring (useful across desktops)
  # services.gnome.gnome-keyring.enable = true;

  # programs.light.enable = true;
  security.polkit.enable = true;

  # Custom SSH Config
  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentitiesOnly yes
  '';

  # --- REMOVED: Deleted the insecure and non-functional root login
  # configuration ---

  # CUSTOM MINE START
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. It's recommended to leave this value as is.
  # system.stateVersion = "25.11"; # Did you read the comment?
}
