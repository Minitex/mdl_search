#!/bin/bash

set -e

# Script to update the Webpacker image

# Function to display messages
log() {
    echo -e "\n[INFO] $1\n"
}

# Find the container ID of the webpacker container
log "Finding the container ID of the webpacker container..."
CONTAINER_ID=$(docker ps -qa -f name=webpacker)

if [ -n "$CONTAINER_ID" ]; then
    log "Webpacker container found with ID: $CONTAINER_ID"

    # Stop the container if it's running
    log "Stopping the container..."
    docker stop $CONTAINER_ID

    # Remove the container
    log "Removing the container..."
    docker rm $CONTAINER_ID
else
    log "No running webpacker container found."
fi

# Find the image(s)
log "Finding the webpacker image(s)..."
IMAGE_IDS=$(docker images mdl_search_webpacker -q)

if [ -n "$IMAGE_IDS" ]; then
    log "Webpacker images found. Removing images..."
    docker rmi $IMAGE_IDS
else
    log "No webpacker images found."
fi

# Build the new image
log "Building the new webpacker image..."
docker-compose build webpacker

# Run the container
log "Starting the webpacker container..."
docker-compose up -d webpacker

log "Webpacker image updated and container started successfully!"
