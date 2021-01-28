{ pkgs, config, lib, ... }:
{
  wayland.windowManager.sway =
  let
    swaymsg = "${pkgs.sway}/bin/swaymsg";

    alacritty = "${pkgs.alacritty}/bin/alacritty";
    bemenu = "${pkgs.bemenu}/bin/bemenu";
    gtk-launch = "${pkgs.gnome3.gtk}/bin/gtk-launch";
    j4-dmenu-desktop = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
    wob = "${pkgs.wob}/bin/wob";

    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    brightnessIncrement = "8";

    pamixer = "${pkgs.pamixer}/bin/pamixer";
    audioIncrement = "10";
    smallAudioIncrement = "5";

    cut = "${pkgs.coreutils}/bin/cut";
    head = "${pkgs.coreutils}/bin/head";
    mkfifo = "${pkgs.coreutils}/bin/mkfifo";
    sed = "${pkgs.gnused}/bin/sed";
    tail = "${pkgs.coreutils}/bin/tail";
  in
  {
    enable = true;

    config = {
      terminal = "${alacritty}";

      menu = "${j4-dmenu-desktop} --dmenu='${bemenu} -i -m all' --term='${alacritty}'";

      startup = [
        { command = "${mkfifo} $SWAYSOCK.wob && ${tail} -f $SWAYSOCK.wob | ${wob}"; }
      ];

      keybindings =
      let
        mod = config.wayland.windowManager.sway.config.modifier;
      in
      lib.mkOptionDefault {
        "${mod}+Shift+Return" = "exec '${gtk-launch} chromium-browser-wayland.desktop'";
        "${mod}+Ctrl+Return" = "exec '${gtk-launch} roam-research-wayland.desktop'";

        "XF86MonBrightnessUp" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%+ && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
        "XF86MonBrightnessDown" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%- && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';

        "XF86AudioRaiseVolume" = "exec '${pamixer} -ui ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
        "Shift+XF86AudioRaiseVolume" = "exec '${pamixer} -ui ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
        "XF86AudioLowerVolume" = "exec '${pamixer} -ud ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
        "Shift+XF86AudioLowerVolume" = "exec '${pamixer} -ud ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
        "XF86AudioMute" = "exec ${pamixer} --toggle-mute && ( ${pamixer} --get-mute && echo 0 > $SWAYSOCK.wob ) || ${pamixer} --get-volume > $SWAYSOCK.wob";
      };
    };
  };
}