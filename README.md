# kognise/dotfiles

My NixOS config, quite fresh so not that fancy.

### Install

**You'll need the bootloader, networking, and `system.stateVersion` parts from your original config to put in `installation.nix`.**

```
sudo cp installation.example.nix installation.nix
sudo nano installation.nix
sudo ln -s "$(pwd)/installation.nix" /etc/nixos/installation.nix

sudo rm /etc/nixos/configuration.nix
sudo ln -s "$(pwd)/configuration.nix" /etc/nixos/configuration.nix

sudo nixos-rebuild switch
```