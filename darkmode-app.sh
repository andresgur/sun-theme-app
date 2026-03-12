#!/bin/bash

CONFIG="$HOME/.config/darkmode-app.conf"
ICON="$HOME/.local/share/icons/darkthemetoggler.png"
INSTALL_DIR="$HOME/.local/bin"
# Load existing lat/lon
if [ -f "$CONFIG" ]; then
# remove the N and E attached to them for the window display
    LAT=$(cut -d',' -f1 "$CONFIG" | cut -d"N" -f1)
    LON=$(cut -d',' -f2 "$CONFIG" | cut -d"E" -f1)
else
    LAT="40.7128"  # default
    LON="-74.0060"
fi

# Ask for lat/lon if not set
result=$(zenity --entry --window-icon=$ICON --title="Dark Mode Setup" --text="Latitude (deg)" --entry-text="$LAT")
if [ $result=="" ]; then
        # user pressed cancel
        exit
else
	LAT=result
fi	
result=$(zenity --entry --window-icon=$ICON --title="Dark Mode Setup" --text="Longitude (deg)" --entry-text="$LON")
if [ $result=="" ]; then
        # user pressed cancel
	exit
else
	LON=result
fi	

# update config file
mkdir -p "$(dirname "$CONFIG")"
LAT="$LAT"N
LON="$LON"E
echo "$LAT,$LON" > "$CONFIG"

# trigger toggle
"$INSTALL_DIR/.local/bin/toggle-theme.sh"



