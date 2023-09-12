{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
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

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "mycomputer";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

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

  home-manager.users.myuser = { pkgs, ... }: {
    home.packages = [

    ];
    programs.bash.enable = true;
    programs.fzf.enable = true;
    programs.git = {
      enable = true;
      userName = "Mika Sundland";
      userEmail = "mika.sundland@gmail.com";
      aliases = {
        adog = "log --all --decorate --oneline --graph";
      };
    };
    home.stateVersion = "23.05";
  };

  environment.systemPackages = with pkgs; [
    ark
    chromium
    fzf
    git
    htop
    hwinfo
    libreoffice-qt
    libsForQt5.kcalc
    libsForQt5.kolourpaint
    kate
    keepassxc
    jetbrains.clion
    nextcloud-client
    okular
    python3Full
    spotify
    tree
    unixtools.xxd
    unzip
    vim
    vlc
    wget
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
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

  system.stateVersion = "23.05";
}
