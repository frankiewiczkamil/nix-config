{ pkgs, lib, ... }:

{
  nixpkgs.system = "aarch64-linux";
  system.stateVersion = "24.11";
  boot = {
    loader = {
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
  nix.settings.trusted-users = [
    "root"
    "pi"
  ];
  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.pi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAX59rFMYi8Rw+m3ragaMYxYLqKzBatAsv1562ndPTTZkDTWWMhTXgNLN4Kh74dANRECrxiQHie33wnIpLAItDEdMPvsFM6/OrdDz7hy7DM67+Fy4Jjxroy/XhBNZNaMPZzfocp+YGecCxouz1BwjtgQqgmxzrwjL9sKeyiG5oQ0S+mtvVUtIs38n9rqVZJDqfSXoYMkwxyZBms6ub26RjqgDx7V0XjKMgujxywyN9tWNu5nN2UEcuixTV3i9FSrsPhhCzY9hAJX09eJic1Yz3hAN5IuhlaiGBcI0Xz4vsTRg13wGYtvTsU7lTbj36G+J47R/5/MO1CkaL/M/DRAHz pi"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  networking = {
    wireless.enable = false;
    networkmanager.enable = false;
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "pikachu";
    useDHCP = true;
  };

  environment.systemPackages = with pkgs; [
    vim
  ];
}
