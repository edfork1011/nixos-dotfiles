-- Hyprland 0.55+ Lua configuration

-- ============================================================
-- General
-- ============================================================

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 10,
    border_size = 0,
    resize_on_border = true,
    layout = "dwindle",
  },

  decoration = {
    rounding = 12,

    blur = {
      enabled = true,
      size = 8,
      passes = 2,
      ignore_opacity = true,
      new_optimizations = true,
      xray = false,
    },

    shadow = {
      enabled = true,
      range = 18;
      render_power = 3;
      color = "rgba(00000026)",
    },
  },

  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,

    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
    },
  },

  animations = {
    enabled = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },
})

-- ============================================================
-- Monitor
-- ============================================================

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1.5,
})

-- ============================================================
-- Environment
-- ============================================================

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- ============================================================
-- Autostart
-- ============================================================

hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d")

  hl.exec_cmd("caelestia-shell")

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- ============================================================
-- Keybinds
-- ============================================================

local mod = "SUPER"

-- Applications
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))

-- Window
hl.bind(mod .. " + X", hl.dsp.window.close())

hl.bind(
  mod .. " + V",
  hl.dsp.window.float({
    action = "toggle",
  })
)

hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

-- Hyprland
hl.bind(
  mod .. " + SHIFT + R",
  hl.dsp.exec_cmd("hyprctl reload")
)

hl.bind(
  mod .. " + SHIFT + E",
  hl.dsp.exit()
)

-- Shell
hl.bind(
  mod .. " + D",
  hl.dsp.global("caelestia:launcher")
)

-- ============================================================
-- Focus
-- ============================================================

hl.bind(
  mod .. " + H",
  hl.dsp.focus({
    direction = "left",
  })
)

hl.bind(
  mod .. " + L",
  hl.dsp.focus({
    direction = "right",
  })
)

hl.bind(
  mod .. " + K",
  hl.dsp.focus({
    direction = "up",
  })
)

hl.bind(
  mod .. " + J",
  hl.dsp.focus({
    direction = "down",
  })
)

-- ============================================================
-- Workspaces
-- ============================================================

for i = 1, 10 do
  local key = i % 10

  -- Switch workspace
  hl.bind(
    mod .. " + " .. key,
    hl.dsp.focus({
      workspace = i,
    })
  )

  -- Move window to workspace
  hl.bind(
    mod .. " + SHIFT + " .. key,
    hl.dsp.window.move({
      workspace = i,
    })
  )
end

-- ============================================================
-- Mouse
-- ============================================================

hl.bind(
  mod .. " + mouse:272",
  hl.dsp.window.drag(),
  {
    mouse = true,
  }
)

hl.bind(
  mod .. " + mouse:273",
  hl.dsp.window.resize(),
  {
    mouse = true,
  }
)
