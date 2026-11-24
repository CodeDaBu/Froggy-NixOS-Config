{config, ...}: let
  animationSpeed = config.theme.animation-speed;

  animationDuration =
    if animationSpeed == "slow"
    then "4"
    else if animationSpeed == "medium"
    then "2.5"
    else "1.5";
  borderDuration =
    if animationSpeed == "slow"
    then "10"
    else if animationSpeed == "medium"
    then "6"
    else "3";
in {
  wayland.windowManager.hyprland.settings.config.animations.enabled = true;

  wayland.windowManager.hyprland.extraConfig = ''
    hl.curve("linear",        { type = "bezier", points = { {0, 0},       {1, 1}       } })
    hl.curve("md3_standard",  { type = "bezier", points = { {0.2, 0},     {0, 1}       } })
    hl.curve("md3_decel",     { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })
    hl.curve("md3_accel",     { type = "bezier", points = { {0.3, 0},     {0.8, 0.15}  } })
    hl.curve("overshot",      { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.1}   } })
    hl.curve("crazyshot",     { type = "bezier", points = { {0.1, 1.5},   {0.76, 0.92} } })
    hl.curve("hyprnostretch", { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.0}   } })
    hl.curve("menu_decel",    { type = "bezier", points = { {0.1, 1},     {0, 1}       } })
    hl.curve("menu_accel",    { type = "bezier", points = { {0.38, 0.04}, {1, 0.07}    } })
    hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0},    {0.15, 1}    } })
    hl.curve("easeOutCirc",   { type = "bezier", points = { {0, 0.55},    {0.45, 1}    } })
    hl.curve("easeOutExpo",   { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
    hl.curve("softAcDecel",   { type = "bezier", points = { {0.26, 0.26}, {0.15, 1}    } })
    hl.curve("md2",           { type = "bezier", points = { {0.4, 0},     {0.2, 1}     } })

    hl.animation({ leaf = "windows",          enabled = true, speed = ${animationDuration}, bezier = "md3_decel",  style = "popin 60%" })
    hl.animation({ leaf = "windowsIn",        enabled = true, speed = ${animationDuration}, bezier = "md3_decel",  style = "popin 60%" })
    hl.animation({ leaf = "windowsOut",       enabled = true, speed = ${animationDuration}, bezier = "md3_accel",  style = "popin 60%" })
    hl.animation({ leaf = "border",           enabled = true, speed = ${borderDuration}, bezier = "default" })
    hl.animation({ leaf = "fade",             enabled = true, speed = ${animationDuration}, bezier = "md3_decel" })
    hl.animation({ leaf = "layersIn",         enabled = true, speed = ${animationDuration}, bezier = "menu_decel", style = "slide" })
    hl.animation({ leaf = "layersOut",        enabled = true, speed = ${animationDuration}, bezier = "menu_accel" })
    hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = ${animationDuration}, bezier = "menu_decel" })
    hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = ${animationDuration}, bezier = "menu_accel" })
    hl.animation({ leaf = "workspaces",       enabled = true, speed = ${animationDuration}, bezier = "menu_decel", style = "slide" })
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = ${animationDuration}, bezier = "md3_decel",  style = "slidevert" })
  '';
}
