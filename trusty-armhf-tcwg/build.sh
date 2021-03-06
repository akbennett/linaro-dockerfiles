#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f *.list *.key
  rm -rf tcwg-buildslave
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')

cp -a ../linaro-*.list ../linaro-*.key .
sed -e "s|@DISTRIBUTION@|${DISTRIBUTION}|" -i *.list

rsync -a ../tcwg-buildslave/ ./tcwg-buildslave/

docker build --tag=linaro/$(basename ${PWD}) .
