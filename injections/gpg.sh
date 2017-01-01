#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --volume ${DOT_GNUPG}:/root/.gnupg \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/gpg:0.0.3 \
  ${@} &&
  true
