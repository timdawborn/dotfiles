#!/bin/bash

xrdb -merge .Xresources
xsetbg -border black -onroot -fullscreen `~/wallpaper/1920x1200/choose.py`
xscreensaver -no-splash &

exec xmonad
