{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixUnstable;
  };
  nix.settings.experimental-features = [ 
	"nix-command"
	"flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
    layout = "no";
  };  

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.myuser = {
     isNormalUser = true;
     extraGroups = [
       "wheel"
       "networkmanager"
     ];
     packages = with pkgs; [
     ];
   };

  environment.systemPackages = with pkgs; [
    chromium
    git
    htop
    tree
    vim
    vlc
    wget
  ];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
	  command = "${pkgs.systemd}/bin/systemctl suspend";
	  options = [ "NOPASSWD" ];
        }
        {
	  command = "${pkgs.systemd}/bin/reboot";
	  options = [ "NOPASSWD" ];
	}
	{
	  command = "${pkgs.systemd}/bin/poweroff";
	  options = [ "NOPASSWD" ];
	}
      ];
      groups = [ "wheel" ];
    }];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
