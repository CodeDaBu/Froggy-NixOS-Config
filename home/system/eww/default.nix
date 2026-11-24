{pkgs, ...}: {
  xdg.configFile."eww/frog.gif".source = ./config/frog.gif;

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    yuckConfig = builtins.readFile ./config/eww.yuck;
    scssConfig = builtins.readFile ./config/eww.scss;
  };
}
