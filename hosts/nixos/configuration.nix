{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix = {
#    package = pkgs.nixUnstable;
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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

  services.xserver = {
    enable = true;
    xkb.layout = "no";
    xkb.variant = "";
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  console = {
    font = "Lat2-Terminus16";
  };

  console.keyMap = "no";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.myuser = {
    isNormalUser = true;
    description = "Myuser";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager.users.myuser = { pkgs, ... }: {
    home.packages = [
      pkgs.bat
      pkgs.bat-extras.batman
      pkgs.bat-extras.batpipe
      pkgs.bat-extras.batgrep
      pkgs.bat-extras.batdiff
      pkgs.bat-extras.batwatch
      pkgs.bat-extras.prettybat
    ];
    programs.bash.enable = true;
    programs.fzf.enable = true;
    programs.git.settings = {
      enable = true;
      userName = "Mika Sundland";
      userEmail = "mika.sundland@gmail.com";
      aliases = {
        adog = "log --all --decorate --oneline --graph";
      };
    };

    home.stateVersion = "24.05";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    ffmpeg_6-headless
    fzf
    git
    gparted
    gpsbabel-gui
    htop
    hwinfo
    libreoffice-qt
    kdiff3
    kdePackages.ark
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.kdenlive
    kdePackages.kolourpaint
    kdePackages.okular
    keepassxc
    kind
    kubectl
    jetbrains.clion
    jetbrains.datagrip
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.rust-rover
    jq
    nextcloud-client
    python315
    spotify
    stremio
    tree
    unixtools.xxd
    unzip
    vim
    vlc
    wget
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
  ];

  nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;

  fonts.fontDir.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    roboto
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


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
