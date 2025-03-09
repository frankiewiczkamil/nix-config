{ pkgs, ... }:

{
  nixpkgs.system = "aarch64-linux";
  system.stateVersion = "24.11";
  boot = {
    loader = {
      # raspberryPi = {
      #   enable = true;
      #   version = 3;
      #   firmwareConfig = ''
      #     core_freq=250
      #   '';
      # };
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      # "reset-raspberrypi" # required for vl805 firmware to load
    ];
  };
  sdImage.compressImage = false;
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  hardware.enableRedistributableFirmware = true;

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;

  users.users.pi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [ "SHA256:sJfjtTKYylkSlgvgN5z+IDk7Figb/8kKPpumLYCcTis" ];
  };

  services.openssh.enable = true;
  networking = {
    hostName = "rpi3";
    firewall.enable = false;
  };
  environment.systemPackages = with pkgs; [
    vim
  ];
}
