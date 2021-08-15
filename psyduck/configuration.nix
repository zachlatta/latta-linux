{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      /home/zrl/dev/nixos-configs/common/base.nix

      /home/zrl/dev/nixos-configs/common/tailscale.nix
      /home/zrl/dev/nixos-configs/common/zrl_user.nix

      /home/zrl/dev/nixos-configs/common/pokedex.nix

      /home/zrl/dev/nixos-configs/psyduck/sway
    ];

  # Enables CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Firmware
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  networking.hostName = "psyduck"; # Define your hostname.
  networking.networkmanager.enable = true; # Get on the interwebz

  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound with Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  fileSystems."/mnt/lugia" = {
    device = "lugia:/";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"

      # don't mount on boot, only when accessed
      "x-systemd.automount"
      "noauto"

      "x-systemd.idle-timeout=600"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

