#!/bin/bash

# `act` is a command line tool that help us test our GitHub Actions Workflows locally using Docker.
# See: https://github.com/nektos/act

act -W ../../.github/workflows/generate-manifests.yml \
    --rebuild \
    --input-file ./.input \
    --secret-file ./.env \
    -P ubuntu-latest=catthehacker/ubuntu:act-latest \
    -P ubuntu-22.04=catthehacker/ubuntu:act-22.04 \
    -P ubuntu-20.04=catthehacker/ubuntu:act-20.04 \
    -P ubuntu-18.04=catthehacker/ubuntu:act-18.04 \
    --container-architecture linux/amd64
