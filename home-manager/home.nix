{ config, pkgs, lib, ... }:

{
  home.username = "bill";
  home.homeDirectory = "/home/bill";
  home.stateVersion = "23.05"; 
  home.packages = [
    pkgs.kitty
  ];
  home.file = {
  
  };
  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs.home-manager.enable = true;
  
  programs = {
    kitty = {
      enable = true;
      environment = { };
      keybindings = { };
      settings = {
        background_opacity = "0.95";
      };
      extraConfig = ''
	# The basic colors
	foreground              #E2E0EC
	background              #0B0A10
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
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-rounded;

    config = rec {
      modifier = "Mod4";
      bars = [ ];

      window = {
	border = 0;
	hideEdgeBorders = "both";
      };

      gaps = {
        inner = 0;
        outer = 0;
      };

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 2%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 2%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 2%+";
        "${modifier}+Return" = "exec kitty";
        "${modifier}+q" = "exec rofi -show drun";
        "${modifier}+w" = "exec google-chrome-stable";
        "${modifier}+z" = "kill";
        "${modifier}+v" = "layout toggle split";
        "${modifier}+c" = "floating toggle";
        "${modifier}+s" = "exec flameshot gui";
        "${modifier}+m" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
      };

      startup = [
        {
          command = "exec i3-msg workspace 1";
          always = true;
          notification = false;
        }
        {
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
	{
	  command = "i3altlayout";
	  always = true;
	  notification = false;
	}
      ];
    };
  };
}

