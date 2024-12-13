#!/bin/bash
docker build \
  --build-arg USER_ID="$(id -u)" \
  --build-arg GROUP_ID="$(id -g)" \
  --build-arg DOCKER_GROUP_ID="$(getent group docker | cut -d ':' -f 3)" \
  -t nonroot-devcontainer .
