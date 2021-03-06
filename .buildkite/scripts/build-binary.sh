#!/bin/bash
set -eo pipefail

# Determine the image and cache tags
IMAGE_TAG=${BUILDKITE_BRANCH}
CACHE_TAG=${IMAGE_TAG}

# Set IMAGE_NAME to something intermediate
IMAGE_NAME="kubekite-intermediate"

# Determine the Dockerfile location
if [ -z "$DOCKERFILE" ]; then
  DOCKERFILE="Dockerfile-buildbinary"
fi

if [ ! -d build/public ]; then
  mkdir -p build/public
fi

git log -1 > build/public/REVISION.txt

# Build the new image
docker build \
  --cache-from $IMAGE_NAME:$CACHE_TAG \
  --tag $IMAGE_NAME:$IMAGE_TAG \
  $EXTRA_TAGS \
  -f $DOCKERFILE \
  .

# Execute the image so that we can get the binary out of it
docker run $IMAGE_NAME:$IMAGE_TAG

# Copy the binary from the container
docker container cp $(docker ps -ql):/go/src/github.com/ProjectSigma/kubekite/cmd/kubekite/kubekite .

# This is a dumb hack to get around a bug in buildkite-agent where
# artifacts cannot be named the same as the directories in which 
# they reside.
# https://github.com/buildkite/agent/issues/694
#
mv kubekite kubekite-bin

# Upload the binary as a Buildkite build artifact
buildkite-agent artifact upload kubekite-bin 
