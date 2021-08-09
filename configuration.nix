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

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    kde-gtk-config
    kgpg
    plasma-browser-integration
    xclip
    libnotify
    file
    jq
  ];

  programs.steam.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.xserver = {
    enable = true;
    layout = "us"; # Set the keyboard layout.
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    brlaser
    brgenml1lpr
    brgenml1cupswrapper
  ];

  sound.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.enable = true;

  # I plan on only using Home Manager for configuration so this should
  # ensure that it doesn't screw any of my packages up.
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  boot.supportedFilesystems = [ "ntfs" ];

  fonts.fonts = with pkgs; [
    # Sans-serif
    inter

    # Monospace
    noto-fonts
    noto-fonts-emoji
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
