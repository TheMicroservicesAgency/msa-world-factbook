#!/bin/bash
#
# Script to build a docker image & push it to the docker hub

NAME=`cat NAME`
VERSION=`cat VERSION`

docker build -t msagency/$NAME:$VERSION . && echo "- Build completed !"
docker build -t msagency/$NAME:latest . && echo "- Build completed !"

echo "- Pushing msagency/$NAME:$VERSION to docker hub"
docker push msagency/$NAME:$VERSION

echo "- Pushing msagency/$NAME:latest to docker hub"
docker push msagency/$NAME:latest
