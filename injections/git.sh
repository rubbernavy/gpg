#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
  --volume ${PASS_STORE}:/usr/local/src \
  --volume ${SUDO_DIR}:/etc/sudoers.d:ro \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/git:0.0.1 \
  ${@} &&
  true
