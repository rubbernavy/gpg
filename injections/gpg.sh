#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --env GPG_OPTS="--pinentry-mode loopback" \
  --volume ${DOT_GNUPG}:/home/user/.gnupg \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/gpg:0.0.3 \
  ${@} &&
  true
