-- ▄▄▄▄· ▪   ▐ ▄ ·▄▄▄▄  .▄▄ ·
-- ▐█ ▀█▪██ •█▌▐███▪ ██ ▐█ ▀.
-- ▐█▀▀█▄▐█·▐█▐▐▌▐█· ▐█▌▄▀▀▀█▄
-- ██▄▪▐█▐█▌██▐█▌██. ██ ▐█▄▪▐█
-- ·▀▀▀▀ ▀▀▀▀▀ █▪▀▀▀▀▀•  ▀▀▀▀
--
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local scripts = "~/.local/bin/"

local terminal = "kitty"
local file_manager = "thunar"
local browser = "firefox-beta"

-- Amount of workspaces used, no more than 10
local workspaces = 4

-- Writing hl.ds.exec_cmd() all the time is too long, here is a shortcut
local function run(cmd, window_rules)
	return hl.dsp.exec_cmd(cmd, window_rules)
end

-- Runs script with given name
local function run_script(script_name)
	return hl.dsp.exec_cmd(scripts .. script_name)
end

-- Generates layout specific binds to avoid hyprland warnings
local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		end
	end
end

-- Launch terminal
hl.bind("SUPER + T", run(terminal))
hl.bind("SUPER + SHIFT + T", run(terminal, { float = true }))

-- Launch some apps
hl.bind("SUPER + B", run(file_manager))
hl.bind("SUPER + N", run(browser))

-- Cycle current workspace layout
hl.bind("SUPER + tab", run_script("cycle_layout"))
hl.bind("SUPER + SHIFT + tab", run_script("cycle_layout --prev"))

-- Reload hyprland config, I have misc.disable_autoreload = true
hl.bind("SUPER + CTRL + R", run("hyprctl reload"))

-- Window actions
hl.bind("SUPER + Q", hl.dsp.window.close()) -- Close window
hl.bind("SUPER + CTRL + Q", hl.dsp.window.kill()) -- Kill window
hl.bind("SUPER + W", hl.dsp.window.center()) -- Centers window if it is floating
hl.bind("SUPER + U", hl.dsp.window.pin()) -- Pins floating window
hl.bind("SUPER + Z", hl.dsp.window.resize({ x = -80, y = -75, relative = true })) -- Make window x-80 y-75 smaller
hl.bind("SUPER + C", hl.dsp.window.resize({ x = 80, y = 75, relative = true })) -- Make window x+80 y+75 bigger
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind("SUPER + SPACE", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end) -- Toggle window floating state and center it.

hl.bind("SUPER + SHIFT + SPACE", function()
	hl.dispatch(hl.dsp.window.float({ action = "off" }))
	hl.dispatch(hl.dsp.window.pseudo())
end) -- Pseudotiles window, ensure it's tiled

-- Current workspace layout based bindings
hl.bind(
	"SUPER + SHIFT + Q",
	layout_bind({
		scrolling = hl.dsp.layout("colresize +conf"), -- Scrolling:, set next column width from config
		dwindle = hl.dsp.layout("movetoroot active"), -- Dwindle: make active window the root window
	})
)

hl.bind(
	"SUPER + SHIFT + W",
	layout_bind({
		scrolling = hl.dsp.layout("colresize -conf"), -- Scrolling: set previous column width from config
	})
)

hl.bind(
	"SUPER + SHIFT + H",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol l"), -- Scrolling: swap column with left one
		dwindle = hl.dsp.layout("swapsplit"), -- Dwindle: swap window split
		monocle = hl.dsp.layout("cycleprev"), -- Monocle and master: cycle prev window
		master = hl.dsp.layout("cycleprev"),
	})
)

hl.bind(
	"SUPER + SHIFT + L",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol r"), -- Scrolling: swap column with right one
		dwindle = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
		monocle = hl.dsp.layout("cyclenext"), -- Monocle and master: cycle next window
		master = hl.dsp.layout("cyclenext"),
	})
)

-- Minimize active window, Press SUPER + X one more time to show it.
-- https://wiki.hypr.land/0.54.0/Configuring/Uncommon-tips--tricks/#minimize-windows-using-special-workspaces
hl.bind("SUPER + X", function()
	hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
	hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
	hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
	hl.dispatch(hl.dsp.window.move({ workspace = "special:minimize" }))
	hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
end)

-- Group binds
hl.bind("SUPER + O", hl.dsp.group.toggle()) -- Create windows group
hl.bind("SUPER + bracketleft", hl.dsp.group.prev()) -- Show previous window in group
hl.bind("SUPER + bracketright", hl.dsp.group.next()) -- Show next window in group

-- dmenu menus
hl.bind("SUPER + CTRL + P", run("cur_p"))
hl.bind("SUPER + V", run("bookmarks-rofi.sh"))
hl.bind("SUPER + E", run("tmux-rofi.sh"))

-- Quickshell
hl.bind("SUPER + R", run("qs ipc call launcher toggle")) -- Restart waybar TODO
hl.bind("SUPER + Y", run("qs ipc call wallpaper toggle")) -- Restart waybar TODO
hl.bind("SUPER + ESCAPE", run("qs ipc call logout toggle")) -- Restart waybar TODO
hl.bind("ALT + ESCAPE", run("qs ipc call popups close")) -- Restart waybar TODO
hl.bind("SUPER + CTRL + N", run("qs ipc call notifications dismiss_all")) -- Restart waybar TODO

-- Misc bindings
hl.bind("SUPER + SHIFT + SPACE", run("qs kill & qs -d"))
hl.bind("SUPER + CTRL + P", run("cur_p"))
hl.bind("SUPER + CTRL + O", run("aura_control cycle"))
hl.bind("XF86ScreenSaver", run("niri msg action power-off-monitors")) -- todo
hl.bind("SUPER + P", run("kitty -e nirimon")) -- niirmon replacement TODO

hl.bind("SUPER + period", run("playerctl next")) -- Play next song
hl.bind("SUPER + comma", run("playerctl previous")) -- Play previous song
hl.bind("SUPER + slash", run("playerctl play-pause")) -- Play or pause song

hl.bind("SHIFT + Print", run_script("screenshot")) -- Screenshot
hl.bind("Print", run_script("screenshot --select")) -- Screenshot selected area
hl.bind("CTRL + Print", run_script("screenrec")) -- Screen record
hl.bind("CTRL + SHIFT + Print", run_script("screenrec --select")) -- Screen record selected area

-- Move focus:   SUPER + arrow keys
-- Move windows: SUPER + CTRL + arrow keys
-- Swap windows: SUPER + SHIFT + arrow keys
-- for _, dir in ipairs({ "a", "d", "w", "s" }) do
-- 	hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
-- 	hl.bind("SUPER + CTRL + " .. dir, hl.dsp.window.move({ direction = dir }))
-- 	hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.swap({ direction = dir }))
-- end
local directions = {
	a = "left",
	d = "right",
	w = "up",
	s = "down",
}

for key, dir in pairs(directions) do
	-- Focus window
	hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))

	-- Move floating or tiled window position
	hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ direction = dir }))

	-- Swap current window with adjacent window
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }))
end

-- Resize active window
hl.bind("SUPER + CTRL + SHIFT + h", hl.dsp.window.resize({ x = -70, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + l", hl.dsp.window.resize({ x = 70, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -70, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 70, relative = true }))

-- Switch workspaces: SUPER + [1-workspaces]
-- Move active window to workspace: SUPER + SHIFT [1-workspaces]
-- Move active window to workspace and follow: SUPER + CTRL [1-workspaces]
for i = 1, workspaces do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
	hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Tag active window
hl.bind("SUPER + backslash", hl.dsp.window.tag({ tag = "bordered" }))
hl.bind("SUPER + SHIFT + backslash", hl.dsp.window.tag({ tag = "opaque" }))

-- Special workspace
hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic", follow = false }))
hl.bind("SUPER + CTRL + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with SUPER + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Laptop specific function key binds
hl.bind("XF86AudioNext", run("playerctl next"), { locked = true })
hl.bind("code:172", run("playerctl play-pause"), { locked = true }) -- XF86AudioPlayPause
hl.bind("XF86AudioPause", run("playerctl pause"), { locked = true })
hl.bind("XF86AudioPlay", run("playerctl play-pause"), { locked = true })
hl.bind("XF86KbdBrightnessUp", run("asusctl leds next"), { locked = true })
hl.bind("XF86KbdBrightnessDown", run("asusctl leds prev"), { locked = true })
hl.bind("Pause", run("playerctl pause"), { locked = true })
hl.bind("XF86AudioMute", run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPrev", run("playerctl previous"), { locked = true })
hl.bind("XF86AudioMicMute", run_script("mictoggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", run("brightnessctl -d amdgpu_bl1 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", run("brightnessctl -d amdgpu_bl1 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86Launch1", run_script("powerprofile next"))
hl.bind("XF86Calculator", run("qalculate-gtk"))
hl.bind("XF86Launch4", run("rog-control-center"))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
