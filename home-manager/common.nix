{ pkgs, ... }: {
  home.packages = with pkgs; [
    killall
    file

    wget
    htop
    glances
    tree

    youtube-dl

    go
    rustc
    cargo
  ];
}