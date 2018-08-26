#!/usr/bin/env bash

song=$(playerctl metadata xesam:title)
artist=$(playerctl metadata xesam:artist)

if [[ $? -ne 0 ]]; then
  exit 0
fi

echo " $song - $artist"
