#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/tree:0.0.2 \
  ${@} &&
  true
