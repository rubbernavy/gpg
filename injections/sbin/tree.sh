#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${WORK}:/home/user/src \
  --workdir /home/user/src \
  --env PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --user user \
  emorymerryman/tree:0.0.2 \
  ${@} &&
  true
