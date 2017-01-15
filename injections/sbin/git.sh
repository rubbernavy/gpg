#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume ${SBIN}:/usr/local/sbin:ro \
  --volume ${BIN}:/usr/local/bin:ro \
  --volume ${SUDO}:/etc/sudoers.d:ro \
  --volume ${WORK}:/home/user/src \
  --workdir /home/user/src \
  --user user \
  emorymerryman/git:0.0.4 \
  ${@} &&
  true
