#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/usr/local/src \
  --volume ${DOT_SSH}:/root/.ssh:ro \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/ssh:0.0.1 \
  ${@} &&
  true
