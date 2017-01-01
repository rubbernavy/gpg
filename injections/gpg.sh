#!/bin/sh

docker \
  run \
  --interactive \
  --tty \
  --rm \
  --volume ${DOT_GNUPG}:/root/.gnupg \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/gpg:0.0.0 \
  ${@} &&
  true
