#!/bin/sh

SBIN=$(docker volume create) &&
  volume(){
    VOLUME=$(docker volume create) &&
      docker \
        run \
          --interactive \
          --rm \
          --volume ${VOLUME}:/usr/local/src \
          emorymerryman/base:0.1.1 \
          chown user:user /usr/local/src &&
          true
      echo ${VOLUME} &&
      true
  } &&
  DOT_PASSWORD_STORE=$(volume) &&
  DOT_GNUPG=$(volume) &&
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
    export DOT_GNUPG=${DOT_GNUPG} &&
      export WORK=/vagrant &&
      docker \
        run \
        --interactive \
        --rm \
        --env GPG_OPTS="--pinentry-mode loopback" \
        --volume ${WORK}:/usr/local/src \
        --volume ${DOT_GNUPG}:/home/user/.gnupg \
        --workdir /usr/local/src \
        --user user \
        emorymerryman/gpg:0.1.0 \
        ${@} &&
        true
      true
  } &&
  gpg --import private.gpg.key &&
  gpg --import public.gpg.key &&
  gpg --import-ownertrust ownertrust.gpg.key &&
  gpg --list-keys &&
  (
    echo BEGIN &&
      docker \
        run \
        --interactive \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume ${SBIN}:/usr/local/sbin:ro \
        emorymerryman/base:0.1.1 \
        cat /usr/local/sbin/pass &&
      echo END &&
      true
  ) &&
  pass init D65D3F8C &&
  echo "GOT CHA" &&
  pass git init &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  pass show &&
  true
