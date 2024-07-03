#!/bin/bash

# Generate unique image names
UBUNTU_IMAGE="ttl.sh/$(uuidgen):10m"
WINDOWS_IMAGE="ttl.sh/$(uuidgen):10m"
MACOS_IMAGE="ttl.sh/$(uuidgen):10m"

# Copy images to registry using skopeo
skopeo copy docker://docker.io/library/alpine:latest docker://${UBUNTU_IMAGE}
skopeo copy docker://docker.io/library/alpine:latest docker://${WINWOWS_IMAGE}
skopeo copy docker://docker.io/library/alpine:latest docker://${MACOS_IMAGE}

# Export environment variables to be available for subsequent steps
echo "UBUNTU_IMAGE=$UBUNTU_IMAGE" >> $GITHUB_ENV
echo "WINDOWS_IMAGE=$WINDOWS_IMAGE" >> $GITHUB_ENV
echo "MACOS_IMAGE=$MACOS_IMAGE" >> $GITHUB_ENV