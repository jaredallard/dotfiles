#!/usr/bin/env bash
#
# Generates stub ssh keys to be imported via chezmoi
set -e -o pipefail

echo "fetching ssh keys ..."
sshKeys=$(op list documents | jq -r '.[] | select(.overview.tags[0] != null) | .uuid+"|"+.overview.title')

echo "creating ssh keys ..."
while read key; do
  uuid=$(awk -F '|' '{ print $1 }' <<< "$key")
  fileName=$(awk -F '|' '{ print $2 }' <<< "$key")

  keyPath="$HOME/.ssh/$fileName"
  if [[ -e "$keyPath" ]]; then
    continue
  fi
  
  echo " --> importing '$fileName' (uuid: $uuid)"

  cat > "$keyPath" << EOF
{{- onepasswordDocument "$uuid" -}}
EOF

  chmod 0600 "$keyPath"
  
  echo " --> adding '$fileName' to chemozi"
  chezmoi add --template "$keyPath"
done <<< "$sshKeys"
echo "done"
