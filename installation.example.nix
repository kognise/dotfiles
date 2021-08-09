{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dazzler";
  time.timeZone = "America/New_York";

  services.xserver.displayManager.setupCommands =
    let xrandr = "${pkgs.xlibs.xrandr}/bin/xrandr";
    in ''
      ${xrandr} --output HDMI-1 --mode 1920x1200 --pos 0x0
      ${xrandr} --output HDMI-0 --mode 1920x1200 --pos 1920x0 --primary
      ${xrandr} --output DP-0   --mode 1920x1200 --pos 3840x0
    '';

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
