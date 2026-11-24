-- Hyprland config (Lua), ported from the previous home-manager hyprland.conf

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "",        mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "eDP-2",   mode = "highres",   position = "0x0",  scale = 1 })
hl.monitor({ output = "desc:AOC U34G2G1 0x00000E06", mode = "3440x1440@99.98", position = "auto", scale = 1 })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user enable --now hyprpaper.service")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("eww daemon")
    hl.exec_cmd("protonvpn-app --start-minimized")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("ANKI_WAYLAND", "1")
hl.env("DISABLE_QT5_COMPAT", "0")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("DIRENV_LOG_FORMAT", "")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 16,

        border_size = 2,

        col = {
            active_border   = "rgb(7ed88a)",
            inactive_border = "rgba(0d1b10EE)",
        },

        resize_on_border = true,

        layout = "master",
    },

    group = {
        col = {
            border_active        = "rgb(7ed88a)",
            border_inactive      = "rgb(4a6b50)",
            border_locked_active = "rgb(4cc5b0)",
        },
        groupbar = {
            text_color = "rgb(c8e6ce)",
            col = {
                active   = "rgb(7ed88a)",
                inactive = "rgb(4a6b50)",
            },
        },
    },

    decoration = {
        rounding         = 0,
        active_opacity   = 0.96,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 3,
            color        = "rgba(0d1b1099)",
        },

        blur = {
            enabled = true,
            size    = 18,
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        allow_small_split = true,
        mfact             = 0.5,
        new_status        = "slave",
    },

    cursor = {
        default_monitor     = "eDP-2",
        no_hardware_cursors = true,
    },

    ecosystem = {
        no_update_news = true,
    },

    misc = {
        background_color         = "rgb(0d1b10)",
        disable_autoreload       = true,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        focus_on_activate        = true,
    },
})

----------------------
---- ANIMATIONS ------
----------------------

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

hl.animation({ leaf = "windows",          enabled = true, speed = 2.5, bezier = "md3_decel",  style = "popin 60%" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 2.5, bezier = "md3_decel",  style = "popin 60%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 2.5, bezier = "md3_accel",  style = "popin 60%" })
hl.animation({ leaf = "border",           enabled = true, speed = 6,   bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 2.5, bezier = "md3_decel" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 2.5, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 2.5, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 2.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 2.5, bezier = "menu_accel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 2.5, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "md3_decel",  style = "slidevert" })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "caps:escape",

        follow_mouse      = 1,
        sensitivity       = 0.5,
        numlock_by_default = true,
        repeat_delay      = 300,
        repeat_rate       = 50,

        touchpad = {
            clickfinger_behavior = true,
            natural_scroll       = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

local mod      = "SUPER"
local shiftMod = "SUPER + SHIFT"

hl.bind(shiftMod .. " + A",      hl.dsp.exec_cmd("/nix/store/4zyl5dcrhgblazrfy90ragavd34wav2b-menu/bin/menu"))
hl.bind(mod .. " + B",           hl.dsp.exec_cmd("uwsm app -- /nix/store/xmdnmy29g6h59jws26j0g8lz21rym5bp-helium-wrapped/bin/helium"))
hl.bind(mod .. " + X",           hl.dsp.exec_cmd("/nix/store/rq97b3qn3c1lqlzmap4z1d7rl3vphmgs-menu/bin/menu"))
hl.bind(mod .. " + RETURN",      hl.dsp.exec_cmd("uwsm app -- /nix/store/r8g7wx039a0kcc3chmxrni9qflxjs802-ghostty-1.3.1/bin/ghostty"))
hl.bind(mod .. " + E",           hl.dsp.exec_cmd("uwsm app -- /nix/store/ak2bqb5a6ajnwy9p6lnsm13n3h994j8v-thunar-4.20.8/bin/thunar"))
hl.bind(mod .. " + SPACE",       hl.dsp.exec_cmd("pgrep -x fuzzel && pkill -x fuzzel || uwsm app -- fuzzel"))
hl.bind(mod .. " + D",           hl.dsp.exec_cmd("/nix/store/3lv5y03zjff0ya8manxii70hz2442664-dashboard-toggle"))
hl.bind(mod .. " + V",           hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + Q",           hl.dsp.exec_cmd([[sh -c 'if timeout 2 eww active-windows 2>/dev/null | grep -q "^dashboard"; then timeout 2 eww close dashboard-tabs dashboard || pkill -x eww; else hyprctl dispatch "hl.dsp.window.close()"; fi']]))
hl.bind(mod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(shiftMod .. " + F",      hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(shiftMod .. " + H", hl.dsp.focus({ monitor = "-1" }))
hl.bind(shiftMod .. " + J", hl.dsp.layout("removemaster"))
hl.bind(shiftMod .. " + K", hl.dsp.layout("addmaster"))
hl.bind(shiftMod .. " + L", hl.dsp.focus({ monitor = "+1" }))

hl.bind(shiftMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"))
hl.bind("Print",            hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/Screenshots"))

-- Workspaces 1-9 on the number row (keycodes 10-18)
for i = 1, 9 do
    hl.bind(mod .. " + code:" .. (9 + i),             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + code:" .. (9 + i),     hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
hl.bind("XF86AudioStop",         hl.dsp.exec_cmd("playerctl stop"),        { locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),     { locked = true })

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + R",         hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "helium-fullscreen",
    match = { class = "helium" },
    suppress_event  = "fullscreen",
    sync_fullscreen = false,
})

hl.window_rule({
    name  = "proton-authenticator",
    match = { class = "proton-authenticator" },
    float  = true,
    center = true,
    size   = "500 400",
})

hl.window_rule({
    name  = "protonvpn-app",
    match = { class = "protonvpn-app" },
    float  = true,
    center = true,
    size   = "500 400",
})

hl.window_rule({
    name  = "run-bg",
    match = { title = "run-bg" },
    float  = true,
    center = true,
    size   = "700 80",
})
