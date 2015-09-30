#!/bin/sh

xrandr --newmode "1656x1050_60.00"  144.75  1656 1760 1936 2216  1050 1053 1063 1089 -hsync +vsync

xrandr --addmode VGA-0 "1656x1050_60.00"

xrandr --output VGA-0 --mode "1656x1050_60.00"
