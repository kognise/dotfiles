{ config, pkgs, ... }:

{
  users.users.kognise = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    hashedPassword = "$6$Xbkutbcm1G8$P.OVMoq/1eKU48ZSwOL8FIOfdojyRBNag6vxc2vMjr1IAOqjMhb0GVODxCK9ZbXgIfhGaD2rs8PNIW3xXFYeP0";
    shell = pkgs.zsh;

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
      okular
      vscode
      alacritty
      starship
      gotop
      ark
      obsidian
      gwenview
      zoom-us
      rustup
      firefox
      reaper
      minecraft
      jre8
      appimage-run
      osu-lazer
      exa
      fzf
      zoxide

      # Theoretically required for VSCode
      desktop-file-utils
      libsecret
      gnome.gnome-keyring
    ];
  };

  home-manager.users.kognise = {
    home.sessionVariables.GIT_YOINK_ROOT = "~/Documents/Programming/";

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
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      autocd = true;

      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        eval "$(zoxide init zsh)"
      '';

      shellAliases = {
        skate = "SUDO_EDITOR=kate sudoedit";
        open = "xdg-open";
        ls = "exa";
        la = "ls -la";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "Aloxaf/fzf-tab"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-history-substring-search"; }
        ];
      };
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
}