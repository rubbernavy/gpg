#!/bin/sh

mkdir /usr/local/bin/bin &&
  DOT_PASSWORD_STORE=$(docker volume create) &&
  DOT_GNUPG=$(docker volume create) &&
  DOT_SSH=$(docker volume create) &&
  sed \
    -e "s#\${DOT_PASSWORD_STORE}#${DOT_PASSWORD_STORE}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    -e "s#\${DOT_SSH}#${DOT_SSH}#" \
    -e "w/usr/local/bin/bin/pass" \
    /vagrant/pass.sh &&
  chmod 0555 /usr/local/bin/bin/pass &&
  gpg(){
    export DOT_GNUPG=${DOT_GNUPG} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${DOT_GNUPG}:/root/.gnupg \
        --volume /vagrant:/usr/local/src:ro \
        --entrypoint /usr/bin/gpg \
        --workdir /usr/local/src \
        emorymerryman/pass:0.8.3 \
        --no-tty \
        --batch \
        ${@} &&
        true
  } &&
  gpg --import private.gpg.key &&
  gpg --import public.gpg.key &&
  gpg --import-ownertrust ownertrust.gpg.key &&
  ( gpg --list-keys || echo WTF ) &&
  pass init D65D3F8C &&
  pass git init &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  pass show &&
  true
