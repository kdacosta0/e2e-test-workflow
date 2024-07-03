#!/bin/bash
set -e

UBUNTU_IMAGE="ttl.sh/$(uuidgen):10m"

skopeo copy docker://docker.io/library/alpine:latest docker://$UBUNTU_IMAGE