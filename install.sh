#!/bin/bash

install_package() {
    PKG=$1

    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y "$PKG"

    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "$PKG"

    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm "$PKG"

    else
        echo "No supported package manager found."
        echo "Please install $PKG manually."
        exit 1
    fi
}

set -e

INSTALL_DIR="$HOME/.local/bin"
SYSTEMD_DIR="$HOME/.config/systemd/user"
DESKTOP_DIR="$HOME/.local/share/applications"
APP=darkmode-app.sh

echo "Checking dependencies..."

# sunwait
if ! command -v sunwait >/dev/null 2>&1; then
    echo "Installing sunwait..."
	
    if command -v snap >/dev/null 2>&1; then
        sudo snap install rjd-sunwait
    else
        install_package sunwait
    fi
fi

# zenity
if ! command -v zenity >/dev/null 2>&1; then
    echo "Installing zenity..."
    install_package zenity
fi

echo "Installing scripts..."

mkdir -p "$INSTALL_DIR"
cp toggle-theme.sh "$INSTALL_DIR/"
cp $APP "$INSTALL_DIR/"

chmod +x "$INSTALL_DIR/"*.sh


echo "Installing systemd units..."

mkdir -p "$SYSTEMD_DIR"
cp systemd/toggle-dark.service "$SYSTEMD_DIR/"
cp systemd/toggle-dark.timer "$SYSTEMD_DIR/"

echo "Reloading systemd..."

systemctl --user daemon-reload
systemctl --user enable --now toggle-dark.timer

echo "Launching setup to enter your latitude/longitude..."
"$HOME/.local/bin/$APP"

echo "Creating icon"

# move icon
mkdir -p ~/.local/share/icons
cp icons/sun-theme.png ~/.local/share/icons/sun-theme.png

# create desktop app
mkdir -p $DESKTOP_DIR
cp sun-theme.desktop $DESKTOP_DIR/sun-theme.desktop
update-desktop-database $DESKTOP_DIR

echo "Done."
