#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/usr/local/src \
  --volume ${DOT_SSH}:/root/.ssh:ro \
  --workdir /usr/local/src \
  --env PATH=PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --user user \
  emorymerryman/ssh:0.0.1 \
  ${@} &&
  true
