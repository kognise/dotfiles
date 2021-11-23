{ config, pkgs, ... }:

let
  # Install Home Manager from a specific Git release.
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "b39647e52ed3c0b989e9d5c965e598ae4c38d7ef";
    ref = "release-21.05";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")      # Include Home Managers NixOS package.
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
  environment.systemPackages = with pkgs; [
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

  sound.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.enable = true;

  # I plan on only using Home Manager for configuration so this should
  # ensure that it doesn't screw any of my packages up.
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  boot.supportedFilesystems = [ "ntfs" ];
  networking.firewall.allowedTCPPorts = [ 8080 ];

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
