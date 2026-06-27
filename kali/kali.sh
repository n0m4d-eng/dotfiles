#!/usr/bin/env bash
set -e

IMAGE="${KALI_IMAGE:-kali-custom}"
CONTAINER_NAME="kali"
HOME_VOL="$HOME/containers/kali/root"
TOOLS_VOL="$HOME/containers/kali/tools"
WORDLISTS_VOL="$HOME/containers/kali/wordlists"

mkdir -p "$HOME_VOL" "$TOOLS_VOL" "$WORDLISTS_VOL"

# Resume existing running container
if docker ps -q --filter "name=^${CONTAINER_NAME}$" | grep -q .; then
    exec docker exec -it "$CONTAINER_NAME" bash
fi

# Remove any stopped container
docker rm "$CONTAINER_NAME" 2>/dev/null || true

exec docker run -it \
    --name "$CONTAINER_NAME" \
    --network host \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    -v "$HOME_VOL":/root \
    -v "$TOOLS_VOL":/opt/tools \
    -v "$WORDLISTS_VOL":/wordlists \
    "$IMAGE" bash
