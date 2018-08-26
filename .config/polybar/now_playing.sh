#!/usr/bin/env bash

song=$(playerctl metadata xesam:title 2>&1)
artist=$(playerctl metadata xesam:artist 2>&1)

if grep "No players found" <<<"${song}" >/dev/null; then
  echo ""
  exit 0
fi

echo "    $artist - $song"
