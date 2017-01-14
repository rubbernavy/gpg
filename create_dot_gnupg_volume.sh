#!/bin/sh

SBIN=$(docker volume create) &&
  DOT_PASSWORD_STORE=$(docker volume create) &&
  DOT_GNUPG=$(docker volume create) &&
  sed \
    -e "s#\${DOT_PASSWORD_STORE}#${DOT_PASSWORD_STORE}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    /vagrant/injections/sbin/pass.sh | docker \
    run \
    --interactive \
    --rm \
    --volume ${SBIN}:/usr/local/sbin \
    --workdir /usr/local/sbin \
    emorymerryman/base:0.1.1 \
    tee pass &&
  docker \
    run \
    --interactive \
    --rm \
    --volume ${SBIN}:/usr/local/sbin \
    --workdir /usr/local/sbin \
    emorymerryman/base:0.1.1 \
    chmod 0500 pass &&
  pass(){
    docker \
      run \
      --interactive \
      --rm \
      --volume /var/run/docker.sock:/var/run/docker.sock:ro \
      --volume ${SBIN}:/usr/local/sbin:ro \
      emorymerryman/base:0.1.1 \
      pass \
      ${@} &&
      true
  } &&
  sed \
    -e "s#\${WORK}#${DOT_PASSWORD_STORE}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    /vagrant/injections/sbin/gpg.sh | docker \
    run \
    --interactive \
    --rm \
    --volume ${SBIN}:/usr/local/sbin \
    --workdir /usr/local/sbin \
    emorymerryman/base:0.1.1 \
    tee gpg &&
  docker \
    run \
    --interactive \
    --rm \
    --volume ${SBIN}:/usr/local/sbin \
    --workdir /usr/local/sbin \
    emorymerryman/base:0.1.1 \
    chmod 0500 gpg &&
  gpg(){
    docker \
      run \
      --interactive \
      --rm \
      --volume /var/run/docker.sock:/var/run/docker.sock:ro \
      --volume ${SBIN}:/usr/local/sbin:ro \
      --volume /vagrant:/vagrant:ro \
      emorymerryman/base:0.1.1 \
      gpg \
      ${@} &&
      true
  } &&
  gpg --import /vagrant/private.gpg.key &&
  gpg --import /vagrant/public.gpg.key &&
  gpg --import-ownertrust /vagrant/ownertrust.gpg.key &&
  gpg --list-keys &&
  true
