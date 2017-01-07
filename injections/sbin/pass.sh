#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume ${SBIN}:/usr/local/sbin:ro \
  --volume ${BIN}:/usr/local/bin:ro \
  --volume ${SUDO}:/etc/sudoers.d:ro \
  --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
  --env PATH=PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --user user \
  emorymerryman/pass:0.6.0 \
  ${@} &&
  true
