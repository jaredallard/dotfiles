#!/bin/bash

# TODO: Load ~/.Xresources here
export LOCALE=en_US.UTF-8

xrdb -merge ~/.Xresources

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
