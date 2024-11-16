#!/bin/bash

TEMP_DIR="/tmp/docker-setup"
mkdir -p $TEMP_DIR

if ! command -v docker &>/dev/null; then
    echo "Docker is not installed. Downloading and installing Docker..."

    curl -fsSL https://get.docker.com -o $TEMP_DIR/get-docker.sh
    sh $TEMP_DIR/get-docker.sh
fi

if ! systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

CONTAINER_NAME="dotfile-env-container"
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "The container $CONTAINER_NAME is already running. Opening a zsh terminal inside it..."
    sudo docker exec -it $CONTAINER_NAME zsh
else
    echo "Running dotfile-env image..."
    sudo docker run -d --rm \
        -v "$HOME/dev:/home/ubuntu/dev" \
        -v "$HOME/.config/github-copilot:/home/ubuntu/.config/github-copilot" \
        -v "/tmp/X11-unix:/tmp/X11-unix" \
        -e DISPLAY="$DISPLAY" \
        --net=host \
        --name="$CONTAINER_NAME" \
        --entrypoint zsh --privileged -ti rachartier/dotfile-dev:latest
    sudo docker exec -it $CONTAINER_NAME zsh
fi
