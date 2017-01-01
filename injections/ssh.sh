#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${DOT_SSH}:/root/.ssh:ro \
  --volumw ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/ssh:0.0.1 \
  ${@} &&
  true
