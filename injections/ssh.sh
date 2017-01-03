#!/bin/sh

sudo docker \
  run \
  --interactive \
  --rm \
  --volume ${DOT_SSH}:/root/.ssh:ro \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/ssh:0.0.1 \
  ${@} &&
  true
