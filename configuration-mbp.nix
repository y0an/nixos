# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  let manualConfig = import ./manual-config.nix;

      linuxPackages_customWithPatches = {version, src, configfile, kernelPatches}:
                                         let linuxPackages_self = (pkgs.linuxPackagesFor (linuxManualConfig {
					                                                                inherit version src configfile kernelPatches;
					                                                                allowImportFromDerivation=true;})
	                                                           linuxPackages_self);
  		                          in pkgs.recurseIntoAttrs linuxPackages_self;
      linuxManualConfig = buildLinux;
      buildLinux = manualConfig {
        inherit (pkgs) stdenv runCommand nettools bc perl kmod writeTextFile ubootChooser openssl;
      };

				  
in { 
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  # Use the gummiboot efi boot loader.
  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;
#  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.kernelPackages = linuxPackages_customWithPatches {  
#    version = "4.2.0";
#    configfile = /etc/nixos/linux/kernel.config;
#    
#    src = pkgs.fetchurl {
#      url    = "https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.2.tar.xz";
#      sha256 = "cf20e044f17588d2a42c8f2a450b0fd84dfdbd579b489d93e9ab7d0e8b45dbeb";
#    };
#
#    kernelPatches = [];
#  };
  boot.kernelPackages = linuxPackages_customWithPatches {
    version = "4.3.0-rc6";
    configfile = /etc/nixos/linux/kernel.config;
    
    src = pkgs.fetchurl {
      url    = "https://www.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.3-rc6.tar.xz";
      sha256 = "fbf68fe15dfa71c0bd18a067db57ddbc40b12440602df4d1cb4aee26f1a02ea2";
    };

    kernelPatches = [];
};

  boot.kernelParams = [ "ipv6.disable=1" "video=eDP-1:1920x1200@60" ];
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
     alias snd-card-0 snd-hda-intel
     alias sound-slot-0 snd-hda-intel
     options snd_hda_intel power_save=1
     options snd slots=snd-hda-intel,snd-usb-audio
     options snd-hda-intel id=PCH,HDMI index=1,0
     options hid_apple fnmode=2
  '';

  hardware.enableAllFirmware = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = "127.0.0.1 nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Denver";
  
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    ack
#    androidsdk_4_4
#    android-udev-rules
    autorandr
    chromium
    clementine
    cmake
    clojure
    dmidecode
    docker
    emacs
    efivar
    ethtool
    file
    firefoxWrapper
    gimp
    git
    gnupg
    gnutls
    google_talk_plugin
    gstreamer
    hipchat
    htop	
    idea.idea-ultimate
    inetutils
    iperf
    kde4.kdemultimedia
    kde4.kdegraphics
    kde4.kdeutils
    kde4.applications
    kde4.kdebindings
    kde4.kdeaccessibility
    #kde4.kde_baseapps
    kde4.kactivities
    kde4.kdeadmin
    kde4.kdeartwork
    #kde4.kde_base_artwork
    kde4.kdenetwork
    kde4.kdepim
    kde4.kdepimlibs
    kde4.kdeplasma_addons
    kde4.kdesdk
    #kde4.kde_wallpapers
    kde4.kdewebdev
    #kde4.oxygen_icons
    kde4.kdebase_workspace
    kde4.kdelibs
    kde4.kdevplatform
    kde4.kopete
    kde4.kmix
    kde4.konversation
    kde4.okular
    libmtp
    libcanberra_kde
    lshw
    lsof
    maven
    mplayer
    mtpfs
    ncdu
    nix-repl
    nodejs
    nox
    openvpn
    openssl
    oraclejdk8
    parted
    patchelf
    pciutils
    pmtools
    psmisc
    phonon_backend_vlc
    python27Packages.pyserial
    sbt
    skype
    spotify
    strategoPackages.strategoxt
    sudo
    terminator
    tig       
    tree	      
    unrar
    unzip
    usbutils
    vlc
    wget
    zip
    zsh
  ];
  ## KDE 5
  ##++ builtins.filter stdenv.lib.isDerivation (builtins.attrValues kdeApps_stable);

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;
  services.nixosManual.showManual = true;
  services.logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
#  services.mbpfan.enable = false;
#  services.virtualboxHost.enable = true;

#  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    
    layout = "us";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.kde4.enable = true;

    synaptics.enable = true;
    synaptics.buttonsMap = [ 1 3 2];
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.tapButtons = true;
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    monitorSection = ''
      Modeline "2560x1600"  348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync
      Modeline "1920x1200"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
      Modeline "1680x1050"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
    '';
    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
    resolutions = [ { x = 1920; y = 1200; } ];
  };

  services.udev = {
    extraRules = ''
      # disable wake from S3 on XHC1
      SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
      # disable wake from S4 on ARPT
      SUBSYSTEM=="pci", KERNEL=="0000:03:00.0", ATTR{power/wakeup}="disabled"
      SUBSYSTEM=="firmware", ACTION=="add", ATTR{loading}="-1"
      SUBSYSTEM=="drm", ACTION=="change", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/jsimpson/.Xauthority", RUN+="/run/current-system/sw/bin/autorandr -c"
    '';
  };

  users.extraGroups = { adbusers = { }; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "adbusers" "dialout" "vboxusers" "docker" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    firefox.enableGoogleTalkPlugin = true;
    firefox.enableAdobeFlash = true;

#    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: rec {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;

      idea.idea-ultimate = pkgs.idea.idea-ultimate.override rec {
        src = pkgs.fetchurl {
          url    = "https://download.jetbrains.com/idea/ideaIU-14.1.5.tar.gz";
          sha256 = "6912902ec97a57f5553247367d6dd5b8e3041e99faf32c48b672cd31413dab73";
        };
      };

      firmwareLinuxNonfree = pkgs.stdenv.lib.overrideDerivation pkgs.firmwareLinuxNonfree (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "fooblahblah";
          repo = "linux-firmware";
    	   rev = "57d7e456ee321e369516cfc50f2e72e4069758e5";
	   sha256 = "1yz72dss5wcibvabfc2p3nc6gkawcnwwnnh0qgvz0zmzy370di9r";
        };
      });
    };
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
