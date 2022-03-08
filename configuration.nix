{ config, pkgs, ... }:

let
  # Install Home Manager from a tarball.
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")      # Include Home Manager's NixOS package.
    /etc/nixos/hardware-configuration.nix # Include the automatic hardware scan results.
    
    ./users/kognise.nix # Include user-specific configuration for kognise.
    ./installation.nix  # Include configuration specific to this installation.
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  hardware.opengl.driSupport32Bit = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays =
    let
      moz-rev = "master";
      moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";};
      nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
    in [
      nightlyOverlay
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-13.6.9"
  ];

  environment.systemPackages = with pkgs; [
    alsa-utils
    kde-gtk-config
    kgpg
    plasma-browser-integration
    xclip
    libnotify
    file
    jq
    git
    libwacom
    clang
    pkgconfig
    xorg.libX11
    xorg.libXrandr
    libsecret
    unzip
    lutris
  ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  virtualisation.libvirtd.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  programs = {
    steam.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    ssh.startAgent = false;
  };

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];

    xserver = {
      enable = true;
      layout = "us"; # Set the keyboard layout.
      desktopManager.plasma5.enable = true;
      displayManager.sddm.enable = true;
      wacom.enable = true;
    };

    gnome.gnome-keyring.enable = true;

    printing.enable = true;
    printing.drivers = with pkgs; [
      gutenprint
      gutenprintBin
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  # Audio via PipeWire, no PulseAudio here!
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    media-session.config.alsa-monitor = {
      actions = {
        update-props = {
          api.alsa.headroom = 512;
        };
      };
    };
  };

  # I plan on only using Home Manager for configuration so this should
  # ensure that it doesn't screw any of my packages up.
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # Add support for NTFS.
  boot.supportedFilesystems = [ "ntfs" ];

  fonts.fonts = with pkgs; [
    inter
    noto-fonts
    noto-fonts-emoji
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    wineWowPackages.fonts
    corefonts
  ];

  # Force all users to be defined solely from NixOS configuration.
  users.mutableUsers = false;
}
