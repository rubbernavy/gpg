#!/bin/sh

echo DOT_SSH=${DOT_SSH} &&
docker \
  run \
  --interactive \
  --rm \
  --env GPG_OPTS="--pinentry-mode loopback" \
  --volume ${DOT_GNUPG}:/home/user/.gnupg \
  --volume ${SRC_DIR}:/usr/local/src \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/gpg:0.0.4 \
  ${@} &&
  true
