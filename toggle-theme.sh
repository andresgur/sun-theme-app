#!/bin/bash
CONFIG="$HOME/.config/darkmode-app.conf"
if [ -f "$CONFIG" ]; then
    LAT=$(cut -d',' -f1 "$CONFIG")
    LON=$(cut -d',' -f2 "$CONFIG")
else
    LAT="40.7128N"  # default
    LON="-74.0060E"
fi

#!/bin/bash
# Determine current time
NOW=$(date +%s)

# Get next sunrise and sunset timestamps
SUNTIMES=$(rjd-sunwait.sunwait list 1 rise set civil $LAT $LON)
IFS=',' read -r SUNRISE SUNSET <<< "$SUNTIMES"

echo "SUNRISE TIME for $LAT,$LON: $SUNRISE"
echo "SUNSET TIME FOR $LAT,$LON: $SUNSET"
# Convert HH:MM to timestamp today or tomorrow
today=$(date +%Y-%m-%d)
SUNRISE_TS=$(date -d "$today $SUNRISE" +%s 2>/dev/null || date -d "tomorrow $SUNRISE" +%s)
SUNSET_TS=$(date -d "$today $SUNSET" +%s 2>/dev/null || date -d "tomorrow $SUNSET" +%s)

# get current theme --> remove quotations for the string comparison
current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme| tr -d "'"))
# Set theme based on current time
if [ $NOW -ge $SUNSET_TS ] || [ $NOW -lt $SUNRISE_TS ] ; then
	target_theme='Yaru-dark'
else
	target_theme='Yaru-light'
fi
if [ "$current_theme" != "$target_theme" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme $target_theme
    echo "System set to $target_theme"
fi
