#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/home/user/src \
  --workdir /home/user/src \
  --user user \
  emorymerryman/tree:0.0.2 \
  ${@} &&
  true
