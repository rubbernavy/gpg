#!/bin/sh

inject(){
  PROGRAM=${1} &&
    ROOT_BIN_DIR=${2} &&
    SRC_DIR=${3} &&
    USR_BIN_DIR=${4} &&
    SUDO_DIR=${5} &&
    DOT_SSH=${6} &&
    DOT_GNUPG=${7} &&
    sed \
      -e "s#\${SRC_DIR}#${SRC_DIR}#" \
      -e "s#\${USR_BIN_DIR}#${USR_BIN_DIR}#" \
      -e "s#\${SUDO_DIR}#${SUDO_DIR}#" \
      -e "s#\${DOT_SSH}#${DOT_SSH}#" \
      -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
      /vagrant/injections/${PROGRAM}.sh | docker \
      run \
      --interactive \
      --tty \
      --rm \
      --volume ${ROOT_BIN}:/root/bin \
      alpine:3.4 \
      tee /root/bin/${PROGRAM} &&
    docker \
      run \
      --interactive \
      --tty \
      --rm \
      alpine:3.4 \
      chmod 0500 /root/bin/${PROGRAM} &&
    docker \
      run \
      --interactive \
      --tty \
      --rm \
      --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
      alpine:3.4 \
      ls -1 /usr/local/bin | while read PRG
      do
        echo user ALL = NOPASSWD: /usr/local/${PRG} |
        docker \
          run \
          --interactive \
          --tty \
          --rm \
          --volume ${SUDO_DIR}:/etc/sudoers.d \
          alpine:3.4 \
          tess /etc/sudoers.d/${PRG} &&
        true
  true
} &&
  PASS_STORE=$(docker volume create) &&
  BIN=$(docker volume create --name bin) &&
  DOT_GNUPG=$(docker volume create) &&
  GIT_BIN_DIR=$(docker volume create) &&
  GIT_SUDO_DIR=$(docker volume create) &&
  PASS_BIN_DIR=$(docker volume create) &&
  PASS_SUDO_DIR=$(docker volume create) &&
  inject gpg ${PASS_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} &&
  inject gpg2 ${PASS_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} &&
  inject ssh ${GIT_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} &&
  inject git ${PASS_BIN_DIR} ${PASS_STORE} ${GIT_BIN_DIR} ${GIT_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} &&
  inject pass ${BIN} ${PASS_STORE} ${PASS_BIN_DIR} ${PASS_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} &&
  gpg(){
    export SRC_DIR=/vagrant &&
      export DOT_GNUPG=${DOT_GNUPG} &&
      /usr/bin/sh /vagrant/injections/gpg.sh ${@} &&
      true
  } &&
  gpg --import public.gpg.key &&
  gpg --import private.gpg.key &&
  gpg --import-ownertrust ownertrust.gpg.key &&
  gpg2(){
    export SRC_DIR=/vagrant &&
      export DOT_GNUPG=${DOT_GNUPG} &&
      /usr/bin/sh /vagrant/injections/gpg2.sh ${@} &&
      true
  } &&
  gpg2 --import public.gpg2.key &&
  gpg2 --import private.gpg2.key &&
  gpg2 --import-ownertrust ownertrust.gpg2.key &&

  true
