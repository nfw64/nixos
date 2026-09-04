-- .▄▄ · ▄▄▄▄▄ ▄▄▄· ▄▄▄  ▄▄▄▄▄▄• ▄▌ ▄▄▄·
-- ▐█ ▀. •██  ▐█ ▀█ ▀▄ █·•██  █▪██▌▐█ ▄█
-- ▄▀▀▀█▄ ▐█.▪▄█▀▀█ ▐▀▀▄  ▐█.▪█▌▐█▌ ██▀·
-- ▐█▄▪▐█ ▐█▌·▐█ ▪▐▌▐█•█▌ ▐█▌·▐█▄█▌▐█▪·•
--  ▀▀▀▀  ▀▀▀  ▀  ▀ .▀  ▀ ▀▀▀  ▀▀▀ .▀
--
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local startup = {
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE",
	"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE",
	"systemctl --user start graphical-session.target",
	"quickshell",
	"gsettings set org.gnome.desktop.interface cursor-theme Firefly", -- Set cursor theme in gsettings
	"hyprctl setcursor Firefly 64", -- Set cursor theme for hyprland
	"wl-clip-persist --clipboard regular", -- Enables clipboard persistence
	"wl-paste --type text --watch cliphist -max-items=35 store", -- Enable clipboard for text
	"wl-paste --type image --watch cliphist -max-items=10 store", -- Enable clipboard for images
	"setWal",
	"~/.local/bin/at_startup", -- Misc user defined custom shell scripts
	"gammastep-indicator", -- Bluelight filter
	"/usr/lib/xfce-polkit/xfce-polkit", -- Policy manager (prompts for sudo access if app requests)
	"hypridle",
	"sleep 3 && exec cardwire-gui",
}

hl.on("hyprland.start", function()
	for i = 1, #startup do
		hl.exec_cmd(startup[i])
	end
end)
