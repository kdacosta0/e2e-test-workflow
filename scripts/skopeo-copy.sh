#!/bin/bash

skopeo copy docker://docker.io/library/alpine:latest docker://${UBUNTU_IMAGE}
skopeo copy docker://docker.io/library/alpine:latest docker://${WINWOWS_IMAGE}
skopeo copy docker://docker.io/library/alpine:latest docker://${MACOS_IMAGE}