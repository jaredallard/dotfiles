#!/usr/bin/env bash

song=$(playerctl metadata xesam:title)
artist=$(playerctl metadata xesam:artist)

echo "$song - $artist"
