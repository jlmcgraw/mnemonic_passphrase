#!/bin/bash
set -eu
IFS=$(printf '\n\t')

# Install necessary software
sudo apt install \
        cpanminus \
        carton

# Install the libraries in our cpanfile locally
carton install
