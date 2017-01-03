#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --env GPG_OPTS="--pinentry-mode loopback" \
  --volume ${WORK}:/usr/local/src \
  --volume ${DOT_GNUPG}:/home/user/.gnupg \
  --workdir /usr/local/src \
  --user user \
  emorymerryman/gpg:0.0.4 \
  ${@} &&
  true
