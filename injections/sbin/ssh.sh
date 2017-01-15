#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/home/user/src \
  --volume ${DOT_SSH}:/root/.ssh:ro \
  --workdir /home/user/src \
  --user user \
  emorymerryman/ssh:0.0.1 \
  ${@} &&
  true
