#!/bin/sh

DOT_GNUPG=$(docker volume create --name dot_gnupg) &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg:0.0.0 \
    --import /usr/local/src/public.gpg.key &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg:0.0.0 \
    --import /usr/local/src/private.gpg.key &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg:0.0.0 \
    --import-ownertrust /usr/local/src/ownertrust.gpg.key &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg2:0.0.0 \
    --import /usr/local/src/public.gpg2.key &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg2:0.0.0 \
    --import /usr/local/src/private.gpg2.key &&
  docker \
    run \
    --interactive \
    --tty \
    --detach \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume /vagrant:/usr/local/src:ro \
    emorymerryman/gpg2:0.0.0 \
    --import-ownertrust /usr/local/src/ownertrust.gpg2.key &&
  true
