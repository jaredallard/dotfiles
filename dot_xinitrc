#!/bin/bash

# TODO: Load ~/.Xresources here
export LOCALE=en_US.UTF-8

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

#xrdb -merge ~/.Xresources

exec i3
