# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams =
      [ "acpi_rev_override" "mem_sleep_default=deep" "intel_iommu=igfx_off" "nvidia-drm.modeset=1" ];
    kernelPackages = pkgs.linuxPackages_5_4;
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "128.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.bill = {
    isNormalUser = true;
    description = "bill";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    useDefaultShell = true;
    packages = with pkgs; [];
  };
 
  # Home-Manager for dotfiles

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      displayManager.xpra.pulseaudio = true;
      videoDrivers = [ "nvidia" ];
      windowManager.i3 = {
	enable = true;
	extraPackages = with pkgs; [
	  dmenu
	  i3status
	  i3blocks
          i3-rounded
          i3altlayout
	];
      };
      desktopManager.gnome.enable = true;
      displayManager.sddm.enable = false;
      displayManager.sddm.theme = "where-is-my-sddm-theme";
      displayManager.startx.enable = true;
      config = ''
        Section "Device"
            Identifier "nvidia"
            Driver "nvidia"
            BusID "PCI:1:0:0"
            Option "AllowEmptyInitialConfiguration"
        EndSection
      '';
      screenSection = ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';
    };
    flatpak.enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "bill";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.pathsToLink = [ "/libexec" ];
  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    google-chrome
    firefox
    cinnamon.nemo
    gnome.gnome-tweaks
    btop
    kitty
    pavucontrol
    pipewire
    wireplumber
    pulseaudio
    pamixer
    hyprland
    libnotify
    waybar
    gnome.gnome-tweaks
    sassc
    swww
    brightnessctl
    asusctl
    supergfxctl
    hyprpicker
    slurp
    wf-recorder
    wayshot
    imagemagick
    wl-gammactl
    pavucontrol
    swappy
    python3
    nerdfonts
    gnome.adwaita-icon-theme
    font-awesome
    home-manager
    grim
    slurp
    wl-clipboard
    grimblast
    fzf
    fzf-zsh
    zsh
    eza
    oh-my-zsh
    zsh-powerlevel10k
    zsh-fzf-tab
    steam
    i3
    awesome
    bspwm
    polybar
    rofi
    xorg.xinit
    xorg.xauth
    libsForQt5.sddm
    where-is-my-sddm-theme
    flameshot
    flatpak
    lutris
    alsa-utils
    xwaylandvideobridge
    neofetch
    r2modman
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts
  ];
  # Programs
  programs = {
    hyprland = { 
      enable = true;
    };
    waybar.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      shellAliases = {
        grep = "grep --color=auto";
	ls="eza -s size -a --icons=always --hyperlink";
        mv="mv -v";
	cp="cp -vr";
	rm="rm -vrf";
        v="vim";
	vhypr="vim ~/.config/hypr/hyprland.conf";
	vnix="sudo vim /etc/nixos/configuration.nix";
	vnixh="sudo vim /etc/nixos/hardware-configuration.nix";
	nixr="sudo nixos-rebuild switch";
        vhome="vim ~/.config/home-manager/home.nix";
        homer="home-manager switch";
        hypr="Hyprland";
      };
      ohMyZsh = {
	enable = true;
	plugins = ["sudo"];
      };
    };
  };

  # Hardware
  hardware = {
    pulseaudio.enable = false;
    enableAllFirmware = true;
  };
  #sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
