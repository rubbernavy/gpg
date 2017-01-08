#!/bin/sh

docker \
  run \
  --interactive \
  --rm \
  --env GPG_OPTS="--pinentry-mode loopback" \
  --volume ${WORK}:/home/user/src \
  --volume ${DOT_GNUPG}:/home/user/.gnupg \
  --workdir /home/user/src \
  --env PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --user user \
  emorymerryman/gpg:0.0.4 \
  ${@} &&
  true
