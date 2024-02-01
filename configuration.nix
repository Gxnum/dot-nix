# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure how nix works
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    #LC_TIME = "el_GR.UTF-8";
  };

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
      layout = "us,ru";
      xkbOptions = "grp:win_space_toggle";
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
      displayManager.gdm.enable = true;
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.bash;
  users.users.bill = {
    isNormalUser = true;
    description = "bill";
    extraGroups = [ "networkmanager" "wheel" ];
    useDefaultShell = true;
    packages = with pkgs; [
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "bill";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Waydroid for Guardian Tales
  virtualisation.waydroid.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (discord.override {withVencord = true;})
    wget
    git
    vim
    google-chrome
    firefox
    pavucontrol
    pamixer
    hyprland
    xdg-desktop-portal-hyprland
    kitty
    waybar
    hyprpaper
    swaybg
    mako
    grimblast
    libnotify
    btop
    home-manager
    wl-clipboard
    fzf
    fzf-zsh
    zsh
    eza
    oh-my-zsh
    zsh-powerlevel10k
    zsh-fzf-tab
    steam
    qpwgraph
    i3
    xorg.xinit
    xorg.xauth
    r2modman
    neofetch
    xwaylandvideobridge
    mpv
    swaynotificationcenter
    meslo-lgs-nf
    cava
    cinnamon.nemo
    obs-studio
    xarchiver
    starship
    blesh
    gnome.quadrapassel
    kickoff
    tty-clock
    eww
    quickemu
    quickgui
    killall
    gimp
    sassc
    cava
    mpd
  ];

  # Programs
  programs = {
    hyprland = { 
      enable = true;
    };
    waybar.enable = true;
    bash = {
      blesh.enable = true;
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
    };
    starship = {
      enable = true;
      settings = {
	add_newline = true;
        format = "[](fg:#DFA7E7)[$directory](bg:#DFA7E7)[](fg:#DFA7E7 bg:#A8C5E6)$git_branch[](#A8C5E6 bg:#A8E5E6)$time[](#A8E5E6 bg:none) $all$character";
        directory = { style = "bg:#DFA7E7 fg:#161616"; home_symbol = " ~";  };
	git_branch = { format = "[ $symbol$branch ]($style)"; style = "bg:#A8C5E6 fg:#161616";  };
	git_status = { format = "[ $all_status$ahead_behind ]($style)"; style = "bg:#A8E5E6 fg:#161616";  };
	time = { disabled = true; format = "[ $time ]($style)"; style = "bg:#A8C5E6 fg:#161616";  };
      };
    };
    zsh = {
      enable = false;
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
	plugins = [ "sudo" ];
      };
    };
  };


  # Home Manager
  home-manager.users.bill = { pkgs, ... }: {
    home.packages = [
    ];

    services = {
      mako = {
	enable = true;
	font = "JetBrainsMono";
	width = 400;
	height = 80;
	margin = "15";
	padding = "15";
	borderSize = 1;
	borderRadius = 15;
	maxIconSize = 48;
	maxVisible = 10;
	layer = "overlay";
	anchor = "top-right";
	
	backgroundColor = "#161616b3";
	textColor = "#DFA7E7";
	borderColor = "#DFA7E7";
        defaultTimeout = 4000;
	progressColor = "over #433E4A";	
      };
    };

    programs.waybar = {
      enable = true;
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 8px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 15px;
                 margin-right: 15px;
                 margin-top: 5px;
                 background-color: rgba(22, 22, 22, 0.85);
                 padding: 3px;
                 padding-left:8px;
                 border: 2px #dfa7e7;
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background-color: rgba(22, 22, 22, 0.85);
               }
               tooltip label {
                 color: #E2E0EC;
               }
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
         #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: #AAC5A0;
               }
         #cpu {
                 color: #ECE0A8;
               }
         #clock {
                 color: #E2E0EC;
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: #33ccff;
            }
         #temperature {
                 color: #A8E5E6
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: #DFA7E7;
               }
         #network {
                 color: #A8C5E6;
               }
         #network.disconnected {
                 color: #A8E5E6;
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
                 padding-right: 8px;
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "Hack Nerd Font" ;
                 color: #33ccff;
               }
	#workspaces {
		padding: 0 14px;
		
	}
	#workspaces button {
    		padding: 1px 5px;
    		background: transparent;
    		color: #DFA7E7;
	}
	#workspaces button:hover {
    		background: transparent;
	   	color: #A8C5E6;
	}
	#workspaces button.active {
    		background: #DFA7E7;
		color: #161616;
	}
	#workspaces button.urgent {
	   	color: #11111b;
	   	background: #fab387;
	   	border-radius: 10px;
	}
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
	 "hyprland/workspaces"
	 "mpd"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "memory"
          "cpu"
          "network"
          "custom/powermenu"
          "tray"
        ];
        "custom/launcher" = {
          "format" = " ";
          #"on-click" = "pkill rofi || rofi2";
          #"on-click-middle" = "exec default_wall";
          #"on-click-right" = "exec wallpaper_random";
          #"tooltip" = false;
        };
        "custom/cava-internal" = {
          "exec" = "sleep 1s && cava | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'";
          "tooltip" = false;
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
          "tooltip" = false;
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          "tooltip-format"= "<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰐿 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "mpd" = {
          "max-length" = 25;
          "format" = "<span foreground='#bb9af7'></span> {title}";
          "format-paused" = " {title}";
          "format-stopped" = "<span foreground='#bb9af7'></span>";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc update; mpc ls | mpc add";
          "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰍛 {usage}%";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰒢 Connected";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
	"hyprland/workspaces" = {
	 "all-outputs" = true;
	 "on-click" = "activate";
	 "format" = "{icon}";
	 "persistent_workspaces" = {
	   "1" = [];
	   "2" = [];
	   "3" = [];
	   "4" = [];
	   "5" = [];
	   "6" = [];
	   "7" = [];
	   "8" = [];
	   "9" = [];
	 };
	 "format-icons" = {
	   "1" = "I";
	   "2" = "II";
	   "3" = "III";
	   "4" = "IV";
	   "5" = "V";
	   "6" = "VI";
	   "7" = "VII";
	   "8" = "VIII";
	   "9" = "IX";
	   "urgent" = "";
	 };
	};
      }];
    };

    programs.kitty = {
     enable = true;
     environment = { };
     keybindings = { };
     settings = {
       background_opacity = "0.95";
       enable_audio_bell = false;
       confirm_os_window_close  = 0;
     };
     extraConfig = ''
       # The basic colors
       foreground              #E2E0EC
       background              #161616
       selection_foreground    #D9E0EE
       selection_background    #575268
       
       # Transparent Background
       background_opacity 0.8

       # Cursor colors
       cursor                  #F5E0DC
       cursor_text_color       #1E1E2E
       
       # URL underline color when hovering with mouse
       url_color               #F5E0DC
       
       # kitty window border colors
       active_border_color     #C9CBFF
       inactive_border_color   #575268
       bell_border_color       #FAE3B0
       
       # OS Window titlebar colors
       wayland_titlebar_color system
       macos_titlebar_color system
       
       #: Tab bar colors
       active_tab_foreground   #F5C2E7
       active_tab_background   #575268
       inactive_tab_foreground #D9E0EE
       inactive_tab_background #1E1E2E
       tab_bar_background      #161320
       
       # Colors for marks (marked text in the terminal)
       
       mark1_foreground #1E1E2E
       mark1_background #96CDFB
       mark2_foreground #1E1E2E
       mark2_background #F5C2E7
       mark3_foreground #1E1E2E
       mark3_background #B5E8E0
       
       #: The 16 terminal colors
       
       #: black
       color0 #2B273F
       color8 #61588E
       
       #: red
       color1 #E97193
       color9 #E97193
       
       #: green
       color2  #AAC5A0
       color10 #AAC5A0
       
       #: yellow
       color3  #ECE0A8
       color11 #ECE0A8
       
       #: blue
       color4  #A8C5E6
       color12 #A8C5E6
       
       #: magenta
       color5  #DFA7E7
       color13 #DFA7E7
       
       #: cyan
       color6  #A8E5E6
       color14 #A8E5E6
       
       #: white
       color7  #E2E0EC
       color15 #E2E0EC
     '';
    };

    home.stateVersion = "23.11";
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
