#!/bin/bash

CONFIG="$HOME/.config/darkmode-app.conf"
ICON="$HOME/.local/share/icons/darkthemetoggler.png"
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
LAT=$(zenity --entry --window-icon=$ICON --title="Dark Mode Setup" --text="Latitude (deg)" --entry-text="$LAT")
if [ $? -ne 0 ]; then
        # user pressed cancel
        echo ""
        return 1
fi	
LON=$(zenity --entry --title="Dark Mode Setup" --text="Longitude (deg)" --entry-text="$LON")
if [ $? -ne 0 ]; then
        # user pressed cancel
        echo ""
        return 1
fi
mkdir -p "$(dirname "$CONFIG")"
LAT="$LAT"N
LON="$LON"E
echo "$LAT,$LON" > "$CONFIG"


