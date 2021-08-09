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
    /etc/nixos/hardware-configuration.nix # Include the automatic hardware scan results.
    /etc/nixos/installation.nix # Include configuration specific to this installation.
    (import "${home-manager}/nixos") # Include Home Managers NixOS package.
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
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

  users.mutableUsers = false;
  users.users.kognise = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    hashedPassword = "$6$Xbkutbcm1G8$P.OVMoq/1eKU48ZSwOL8FIOfdojyRBNag6vxc2vMjr1IAOqjMhb0GVODxCK9ZbXgIfhGaD2rs8PNIW3xXFYeP0";

    packages = with pkgs; [
      brave
      discord
      _1password-gui
      spotify
      libreoffice
      kate
      neofetch
      nodejs
      yarn
      git
      vscode
      alacritty
      starship
      gotop

      # Theoretically required for VSCode
      desktop-file-utils
      libsecret
      gnome.gnome-keyring
    ];
  };

  home-manager.users.kognise = {
    home.sessionVariables.GIT_YOINK_ROOT = "~/Documents/";

    programs.bash = {
      enable = true;
      shellAliases.skate = "SUDO_EDITOR=kate sudoedit";

      # Sourced in .bash_profile, not .bashrc, so this gets us environment variables
      # in interactive sessions like terminals.
      initExtra = ''
        . "$HOME/.profile"
      '';
    };

    programs.git = {
      enable = true;
      userName = "Kognise";
      userEmail = "felix.mattick@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        user.signingkey = "A31F2D671B0B30E87780DFED7CD21A030279F00B";
        commit.gpgsign = true;
      };
      aliases.get = "!npx git-yoink";
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "FiraCode Nerd Font";

        colors = {
          primary = {
            background = "0x1e2127";
            foreground = "0xabb2bf";
            bright_foreground = "0xe6efff";
          };

          normal = {
            black = "0x1e2127";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0x828791";
          };

          bright = {
            black = "0x5c6370";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0xe6efff";
          };

          dim = {
            black = "0x1e2127";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0x828791";
          };
        };
      };
    };
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

  boot.supportedFilesystems = [ "ntfs" ];

  programs.steam.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
