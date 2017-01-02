#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/tree:0.0.2 \
  ${@} &&
  true
