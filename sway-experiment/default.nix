{ config, pkgs, lib, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      bemenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      gnome3.networkmanagerapplet # For networking
      brightnessctl
    ];
  };

  # For the Sway environment, wanted packages go here.
  #
  # This should be considered temporary until the Sway environment is either
  # refactored into a broader config or killed.
  environment.systemPackages = with pkgs; [
    tree
  ];

  imports = [ <home-manager/nixos> ];

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Zach Latta";
      userEmail = "zach@zachlatta.com";

      ignores = [
# Vim files
''
# Swap
[._]*.s[a-v][a-z]
!*.svg  # comment out if you don't need vector files
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]

# Session
Session.vim
Sessionx.vim

# Temporary
.netrwhist
*~
# Auto-generated tag files
tags
# Persistent undo
[._]*.un~
''
      ];
    };

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      settings = {
        expandtab = true;
        shiftwidth = 2;
      };
    };

    wayland.windowManager.sway =
    # warning: this might be overriding the system installed sway binary
    let
      swaymsg = "${pkgs.sway}/bin/swaymsg";

      alacritty = "${pkgs.alacritty}/bin/alacritty";
      bemenu-run = "${pkgs.bemenu}/bin/bemenu-run";
      wob = "${pkgs.wob}/bin/wob";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      brightnessIncrement = "8";

      cut = "${pkgs.coreutils}/bin/cut";
      head = "${pkgs.coreutils}/bin/head";
      mkfifo = "${pkgs.coreutils}/bin/mkfifo";
      sed = "${pkgs.gnused}/bin/sed";
      tail = "${pkgs.coreutils}/bin/tail";
    in
    {
      enable = true;

      config = {
        output = {
          "*" = {
            scale = "1.5";
          };
        };

        terminal = "${alacritty}";

        menu = "${bemenu-run} -m all --no-exec | xargs ${swaymsg} exec --";

        startup = [
          { command = "${mkfifo} $SWAYSOCK.wob && ${tail} -f $SWAYSOCK.wob | ${wob}"; }
        ];

        keybindings = lib.mkOptionDefault {
          "XF86MonBrightnessUp" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%+ && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
          "XF86MonBrightnessDown" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%- && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
        };
      };
    };
  };
}
