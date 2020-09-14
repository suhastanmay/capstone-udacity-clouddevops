#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Build image
docker build --tag=capstone-project .

# List docker images
docker image ls

# Run flask app
docker run -p 8000:80 capstone-project