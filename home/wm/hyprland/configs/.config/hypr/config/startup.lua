-- .▄▄ · ▄▄▄▄▄ ▄▄▄· ▄▄▄  ▄▄▄▄▄▄• ▄▌ ▄▄▄·
-- ▐█ ▀. •██  ▐█ ▀█ ▀▄ █·•██  █▪██▌▐█ ▄█
-- ▄▀▀▀█▄ ▐█.▪▄█▀▀█ ▐▀▀▄  ▐█.▪█▌▐█▌ ██▀·
-- ▐█▄▪▐█ ▐█▌·▐█ ▪▐▌▐█•█▌ ▐█▌·▐█▄█▌▐█▪·•
--  ▀▀▀▀  ▀▀▀  ▀  ▀ .▀  ▀ ▀▀▀  ▀▀▀ .▀
--
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local startup = {
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE",
	-- "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE",
	-- "systemctl --user start graphical-session.target",
	"quickshell",
	"gsettings set org.gnome.desktop.interface cursor-theme Firefly",
	"hyprctl setcursor Firefly 64",
	"wl-clip-persist --clipboard regular",
	"wl-paste --type text --watch cliphist -max-items=35 store",
	"wl-paste --type image --watch cliphist -max-items=10 store",
	"setWal",
	"~/.local/bin/at_startup", -- Misc user defined custom shell scripts
	"gammastep-indicator",
	"hypridle",
	"sleep 3 && exec cardwire-gui",
	"easyeffects",
}

hl.on("hyprland.start", function()
	for i = 1, #startup do
		hl.exec_cmd(startup[i])
	end
end)
