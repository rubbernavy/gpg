#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/usr/local/src \
  --workdir /usr/local/src \
  --env PATH=PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --user user \
  emorymerryman/tree:0.0.2 \
  ${@} &&
  true
