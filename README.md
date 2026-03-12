# Sun Theme

![App Icon](icons/sun-theme.png)

Automatically switch Ubuntu / GNOME between **Light** and **Dark**
themes based on **sunrise and sunset** at your location.

No background daemon.\
Just a small script + a systemd timer.

------------------------------------------------------------------------

## What it does

-   Detects **sunrise and sunset** using `sunwait`
-   Switches GNOME theme automatically
-   Runs periodically via **systemd user timer**
-   Provides a small **GUI setup script** to configure latitude and
    longitude

------------------------------------------------------------------------

## Requirements

Ubuntu / GNOME system with:

    gsettings
    systemd (user services)
    sunwait
    zenity
    [sunwait](https://github.com/risacher/sunwait)

**sunwait** is used to calculate sunrise and sunset times

------------------------------------------------------------------------

## Install

Clone the repository:

``` bash
git clone https://github.com/yourusername/sun-theme.git
cd sun-theme
```

Run the installer:

``` bash
./install.sh
```

This will:

-   Install scripts to `~/.local/bin`
-   Install systemd units
-   Enable the timer
-   Ask for your latitude and longitude coordinates to calculate the sunrise and sunset times

The configuration will be saved and the timer will automatically handle
switching. If you need to change the coordinates, relaunch the app from the menu "Dark Mode App" or from the `~/.local/bin/darkmode-app.sh`

------------------------------------------------------------------------

## How it works

System architecture:

    systemd timer
            ↓
    toggle-dark.service
            ↓
    toggle-dark-exact.sh
            ↓
    gsettings set org.gnome.desktop.interface color-scheme

The timer periodically checks whether the current time is between
**sunrise and sunset** and applies the correct theme.

**Note**: It may take a while until your theme correctly changes!

------------------------------------------------------------------------

## File Structure

    sun-theme/
    │
    ├── install.sh
    ├── toggle-dark-exact.sh
    ├── dark-toggle-gui.sh
    ├── icon.png
    │
    └── systemd/
        ├── toggle-dark.service
        └── toggle-dark.timer

------------------------------------------------------------------------

## Uninstall

Disable the timer:

``` bash
systemctl --user disable toggle-dark.timer
```

Remove installed files:

    ~/.local/bin/toggle-dark-exact.sh
    ~/.local/bin/dark-toggle-gui.sh
    ~/.config/systemd/user/toggle-dark.*
    ~/.config/darkmode-app.conf

Reload systemd:

``` bash
systemctl --user daemon-reload
```

------------------------------------------------------------------------

## License

GNU

