#!/bin/bash
#
# Script to build & run a docker image

NAME=`cat NAME`
VERSION=`cat VERSION`

docker build -t msagency/$NAME:$VERSION . | tee last_docker_build.out

CONTAINER_ID=`cat last_docker_build.out | grep "Successfully built" | cut -d ' ' -f 3`
rm last_docker_build.out

echo "docker run -ti -p 9904:80 $CONTAINER_ID"
echo "..."
docker run -ti -p 9904:80 $CONTAINER_ID
