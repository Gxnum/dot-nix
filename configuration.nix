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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (discord.override {withVencord = true;})
  # apps
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
    swaybg
    mako
    grimblast
    libnotify
    flatpak
    btop
    home-manager
    wl-clipboard
    fzf
    eza
    steam
    qpwgraph
    gnome.gnome-session
    xorg.xinit
    xorg.xauth
    r2modman
    neofetch
    xwaylandvideobridge
    mpv
    meslo-lgs-nf
    cava
    xarchiver
    starship
    blesh
    gnome.quadrapassel
    quickemu
    quickgui
    killall
    gimp
    fuzzel 
    wlogout
    pmutils
    molly-guard
    wine
    flatpak
    pulsemixer
    skypeforlinux
    wl-color-picker
    libjpeg
    minecraft
    loupe
    gnome.gnome-tweaks
    libadwaita
    bottles
    fragments
    celluloid
    graphs
    escrotum
    gradience
    
  ];

  # Programs
  programs = {
    hyprland.enable = true;
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
	vflake="vim ~/flake.nix";
	rst="sudo alsactl restore && sudo alsactl store";
        #vhome="vim ~/.config/home-manager/home.nix";
        #homer="home-manager switch";
        hypr="Hyprland";
      };
    };
    starship = {
      enable = true;
      settings = {
	add_newline = true;
        format = "[](fg:#78afe3)[$directory](bg:#78afe3)[](fg:#78afe3 bg:#5784b5)$git_branch[](#5784b5 bg:#416994)$time[](#416994 bg:none) $all$character";
        directory = { style = "bg:#78afe3 fg:#161616"; home_symbol = " ~"; read_only_style = "bg:#78afe3 fg:#161616"; };
	git_branch = { format = "[ $symbol$branch ]($style)"; style = "bg:#5784b5 fg:#161616";  };
	time = { disabled = true; format = "[ $time ]($style)"; style = "bg:#5784b5 fg:#161616";  };
      };
    };
  };


  # Home Manager
  home-manager.users.bill = { pkgs, ... }: {
    home.packages = [
    ]; # Color accent = #78afe3

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
	textColor = "#78afe3";
	borderColor = "#78afe3";
        defaultTimeout = 4000;
	progressColor = "over #433E4A";	
      };
    };

    programs.fuzzel = {
      enable = true;
      settings = {
	colors.background = "#1616164D";
	colors.text = "#E2E0ECCC";
	colors.selection-text = "#161616CC";
	colors.selection-match = "#ECE0A8CC";
	colors.match = "#ECE0A8CC";
	colors.selection = "#78afe3CC";
	colors.border = "#78afe3CC";
	border.radius = 10;
	border.width = 2;
        main.width = 60;
	main.font = "monospace:size=18";
	main.prompt = "❯ ";
      };
    };

    programs.kitty = {
      enable = true;
      environment = { };
      keybindings = { };
      settings = {
        background_opacity = "0.7";
        enable_audio_bell = false;
        confirm_os_window_close  = 0;
      };
      extraConfig = ''
        # The basic colors
        foreground              #E2E0EC
        background              #161616
        selection_foreground    #D9E0EE
        selection_background    #262626
        
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
        
        #: black
        color0 #262626
        color8 #262626
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
        color4  #78afe3
        color12 #78afe3
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


    programs.wlogout = {
      enable = true;
      layout = [
	{
	 label = "shutdown";
	 action = "shutdown +0";
	 text = "Touch Grass";
	 keybind = "s";
	 circular = true;
	}
	{
	 label = "reboot";
	 action = "reboot";
	 text = "Restart?";
	 keybind = "r";
	 circular = true;
	}
	{
	 label = "suspend";
	 action = "sudo pm-suspend";
	 text = "A Mimir";
	 keybind = "h";
	 circular = true;
        }
      ]; 
    };

    programs.waybar = {
      enable = true;
      # Styling Waybar
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
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
                 background-color: rgba(0, 0, 0, 0.30);
                 padding-left:8px;
                 border: 2px #dfa7e7;
               }
         tooltip {
                 background-color: rgba(22, 22, 22, 0.70);
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
                 color: #f2f4f8;
               }
         #cpu {
                 color: #f2f4f8;
               }
         #clock {
                 color: #78afe3;
               }
         #pulseaudio {
                 color: #f2f4f8;
               }
         #network {
                 color: #f2f4f8;
               }
         #network.disconnected {
                 color: #f2f4f8;
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
                 padding-right: 8px;
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
	#cava.left, #cava.right {
    		color: #78afe3;
	}
	#cava.left {
    		border-radius: 10px;
	}
	#cava.right {
	}
	#workspaces {
	}
	#workspaces button {
    		color: #78afe3;
		font-size: 24px;
	}
	#workspaces button.active {
		color: #78afe3;
	}
	#workspaces button:hover {
  		box-shadow: none;
  		text-shadow: none;
    		background: none;
    		border: none;
	}
	#workspaces button.urgent {
	   	color: #11111b;
	   	background: #fab387;
	   	border-radius: 10px;
	}
	#custom-sep {
		color: #75A6D7;
		font-size: 18px;
	}
      '';
      # Configuring Waybar
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
	 "hyprland/workspaces"
        ];
        modules-center = [
	 "cava#right"
        ];
        modules-right = [
          "tray"
          "network"
          "memory"
          "cpu"
          "pulseaudio"
          "clock"
        ];
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill wlogout || wlogout";
          #"on-click-middle" = "exec default_wall";
          "on-click-right" = "exec fuzzel";
          "tooltip" = false;
        };
	"cava#left" = {
          "autosens" = 1;
          "bar_delimiter" = 0;
          "bars" = 18;
          "format-icons" = [
            "<span foreground='#cba6f7'>▁</span>"
            "<span foreground='#cba6f7'>▂</span>"
            "<span foreground='#cba6f7'>▃</span>"
            "<span foreground='#cba6f7'>▄</span>"
            "<span foreground='#89b4fa'>▅</span>"
            "<span foreground='#89b4fa'>▆</span>"
            "<span foreground='#89b4fa'>▇</span>"
            "<span foreground='#89b4fa'>█</span>"
          ];
          "framerate" = 60;
          "higher_cutoff_freq" = 10000;
          "input_delay" = 0;
          "lower_cutoff_freq" = 50;
          "method" = "pipewire";
          "monstercat" = false;
          "reverse" = false;
          "source" = "auto";
          "stereo" = true;
          "waves" = false;
        };
	"cava#right" = {
          "autosens" = 1;
          "bar_delimiter" = 0;
          "bars" = 18;
          "format-icons" = [
            "<span foreground='#cba6f7'>▁</span>"
            "<span foreground='#cba6f7'>▂</span>"
            "<span foreground='#cba6f7'>▃</span>"
            "<span foreground='#cba6f7'>▄</span>"
            "<span foreground='#89b4fa'>▅</span>"
            "<span foreground='#89b4fa'>▆</span>"
            "<span foreground='#89b4fa'>▇</span>"
            "<span foreground='#89b4fa'>█</span>"
          ];
          "framerate" = 60;
          "higher_cutoff_freq" = 10000;
          "input_delay" = 0;
          "lower_cutoff_freq" = 50;
          "method" = "pipewire";
          "monstercat" = false;
          "reverse" = false;
          "source" = "auto";
          "stereo" = true;
          "waves" = false;
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
          "on-click" = "pkill wlogout || wlogout";
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
	"hyprland/workspaces" = {
	 "all-outputs" = true;
	 "on-click" = "activate";
	 "format" = "{icon}";
    	 "on-scroll-up" = "hyprctl dispatch workspace e+1";
    	 "on-scroll-down" = "hyprctl dispatch workspace e-1";
	 "format-icons" = {
	   "default" = "";
	   "active" = "";
	   "urgent" = "";
	 };
	};
	"hyprland/window" = {
	 "max-length" = 200;
	 "separate-outputs" = true;
	};
      }];
    };

    gtk = {
      enable = true;
      cursorTheme.package = pkgs.bibata-cursors;
      cursorTheme.name = "Bibata-Modern-Classic";
      cursorTheme.size = 16;
      iconTheme.package = pkgs.morewaita-icon-theme;
      iconTheme.name = "MoreWaita";
      gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = rec {
        modifier = "Mod4";

        window.border = 0;

        gaps = {
          inner = 0;
          outer = 0;
        };

        keybindings = {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 3%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 3%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 3%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 3%+";
          "${modifier}+Return" = "exec kitty";
          "${modifier}+w" = "exec google-chrome-stable";
          "${modifier}+z" = "kill";
          "${modifier}+q" = "exec --no-startup-id dmenu_run";
          "${modifier}+f" = "fullscreen";
          "${modifier}+m" = "exit i3";
          "${modifier}+s" = "exec escrotum -C && notify-send screenie!";
          "${modifier}+k" = "exec killall vinegar";

          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";
        };
      };
    };
    home.stateVersion = "23.11";
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}
