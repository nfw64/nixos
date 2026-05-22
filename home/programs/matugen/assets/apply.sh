#!/usr/bin/env bash

pywalfox update >/dev/null 2>&1 &
kitty +kitten themes --reload-in=all Matugen &

# hyprctl reload &

# GTK
current=$(dconf read /org/gnome/desktop/interface/color-scheme | tr -d "'")

if [[ "$current" == "prefer-dark" ]]; then
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'" &
else
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3'" &

fi
