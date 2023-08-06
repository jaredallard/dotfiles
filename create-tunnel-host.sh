#!/usr/bin/env bash
# Creates a dotfiles tunnel for the current host. Configures bind mounts
# to enable access to the host docker daemon as well as to persist
# certain paths.

IMAGE="ghcr.io/jaredallard/dotfiles:latest"

# Determine the container user's information.
uid=$(docker run --rm --entrypoint=id "$IMAGE" -u)
gid=$(docker run --rm --entrypoint=id "$IMAGE" -g)
userName=$(docker run --rm --entrypoint=id "$IMAGE" -un)

# USER_DIR is the directory that is bind mounted into the container for
# persistence.
USER_DIR="/home/$userName"
if [[ ! -e "$USER_DIR" ]]; then
  echo "User directory '$USER_DIR' does not exist" 2>&1
  echo -e "Create? [y/N]: \c" 2>&1
  read -r response
  if [[ "$response" != "y" ]]; then
    exit 1
  fi

  sudo mkdir -p "$USER_DIR"
fi

echo "==========================================="
echo "Container User Information:"
echo "  UID: $uid"
echo "  GID: $gid"
echo "  Username: $userName"
echo "==========================================="

persistentDirs=(
  "Code"
  ".asdf/"{installs,plugins,shims}
  ".vscode/cli"
)

docker_run_args=(
  # Make all ports accessible to the host as well as use the host
  # hostname.
  "--net=host"

  # Mount the host docker daemon into the container.
  "--volume=/var/run/docker.sock:/var/run/docker.sock"
)

# add the persistent directories to the docker run args.
for dir in "${persistentDirs[@]}"; do
  hostDir="$USER_DIR/$dir"
  if [[ ! -e "$hostDir" ]]; then
    sudo mkdir -p "$hostDir"
    sudo chown "$uid:$gid" "$hostDir"
  fi

  docker_run_args+=("--volume=$hostDir:/home/$userName/$dir")
done

# Add the image last.
docker_run_args+=("$IMAGE")

echo "$(tput bold)IMPORTANT:$(tput sgr0) If this is your first time running this script" \
     "you will need to run 'docker logs -f <container>' and follow the setup instructions" \
     "to finalize the setup."
echo
echo

set -x
exec docker run --rm -d "${docker_run_args[@]}"