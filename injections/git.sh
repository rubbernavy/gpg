#!/bin/sh

docker \
  run \
  --interactive \
  --tty \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
  --volume ${SRC_DIR}:/usr/local/src \
  --volume ${SUDO_DIR}:/etc/sudoers.d:ro \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/ssh:0.0.0 \
  ${@} &&
  true
