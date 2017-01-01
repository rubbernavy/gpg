#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
  --volume ${SUDO_DIR}:/etc/sudoers.d:ro \
  --volume ${PASS_STORE}:/home/user/.password-store \
  --user user \
  emorymerryman/pass:0.0.0 \
  ${@} &&
  true
