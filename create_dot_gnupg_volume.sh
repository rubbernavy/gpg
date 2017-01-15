#!/bin/sh

mkdir ${HOME}/bin &&
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
    -e "w${HOME}/bin/pass" \
    /vagrant/injections/sbin/pass.sh &&
  chmod 0500 ${HOME}/bin/pass &&
  sed \
    -e "s#\${WORK}#${DOT_PASSWORD_STORE}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    -e "w${HOME}/bin/gpg" \
    /vagrant/injections/sbin/gpg.sh &&
    chmod 0500 ${HOME}/bin/gpg &&
  cat ${HOME}/bin/gpg &&
  gpg --import /vagrant/private.gpg.key &&
  gpg --import /vagrant/public.gpg.key &&
  gpg --import-ownertrust /vagrant/ownertrust.gpg.key &&
  ( gpg --list-keys || echo WTF ) &&
  pass init D65D3F8C &&
  echo "GOT CHA" &&
  pass git init &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  pass show &&
  true
