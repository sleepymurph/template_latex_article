#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}" | xargs readlink -f)"
IMAGE_NAME="$(basename "$SCRIPT_DIR")"

# First remove the image
docker rmi "$IMAGE_NAME"

# Then clean up all dangling layers (list, then remove)
docker images -f dangling=true
docker images purge

# For more information on cleaning up unused Docker resources, Digital Ocean
# has an excellent tutorial here:
#
# https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
