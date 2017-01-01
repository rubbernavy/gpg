#!/bin/sh

inject(){
  PROGRAM=${1} &&
    ROOT_BIN_DIR=${2} &&
    SRC_DIR=${3} &&
    USR_BIN_DIR=${4} &&
    SUDO_DIR=${5} &&
    DOT_SSH=${6} &&
    DOT_GNUPG=${7} &&
    docker \
      run \
      --interactive \
      --rm \
      --volume ${ROOT_BIN_DIR}:/root/bin \
      --volume /vagrant/injections:/usr/local/src:ro \
      emorymerryman/base:0.0.5 \
      sed \
        -e "s#\${SRC_DIR}#${SRC_DIR}#" \
        -e "s#\${USR_BIN_DIR}#${USR_BIN_DIR}#" \
        -e "s#\${SUDO_DIR}#${SUDO_DIR}#" \
        -e "s#\${DOT_SSH}#${DOT_SSH}#" \
        -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
        -e "w/root/bin/${PROGRAM}" \
        /usr/local/src/${PROGRAM}.sh &&
    docker \
      run \
      --interactive \
      --rm \
      --volume ${ROOT_BIN_DIR}:/root/bin \
      emorymerryman/base:0.0.5 \
      chmod 0500 /root/bin/${PROGRAM} &&
    docker \
      run \
      --interactive \
      --rm \
      --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
      emorymerryman/base:0.0.5 \
      ls -1 /usr/local/bin | while read PRG
      do
        echo user ALL = NOPASSWD: /usr/local/bin/${PRG} |
        docker \
          run \
          --interactive \
          --rm \
          --volume ${SUDO_DIR}:/etc/sudoers.d \
          emorymerryman/base:0.0.5 \
          tee /etc/sudoers.d/${PRG} &&
        true
      done &&
    true
} &&
  PASS_STORE=$(docker volume create) &&
  BIN=$(docker volume create --name bin) &&
  export DOT_GNUPG=$(docker volume create) &&
  export DOT_SSH=$(docker volume create) &&
  GIT_BIN_DIR=$(docker volume create) &&
  GIT_SUDO_DIR=$(docker volume create) &&
  PASS_BIN_DIR=$(docker volume create) &&
  PASS_SUDO_DIR=$(docker volume create) &&
  inject gpg ${PASS_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} &&
  inject ssh ${GIT_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} &&
  inject git ${PASS_BIN_DIR} ${PASS_STORE} ${GIT_BIN_DIR} ${GIT_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} &&
  inject pass ${BIN} ${PASS_STORE} ${PASS_BIN_DIR} ${PASS_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} &&
  gpg(){
    export SRC_DIR=/vagrant &&
      /usr/bin/sh --login /vagrant/injections/gpg.sh ${@} &&
      true
  } &&
  docker \
    run \
    --interactive \
    --rm \
    --volume ${DOT_GNUPG}:/usr/local/src \
    emorymerryman/base:0.0.5 \
    chown user:user /usr/local/src &&
  echo A &&
  gpg --import --no-tty public.gpg.key &&
  echo B &&
  gpg --import --no-tty private.gpg.key &&
  echo C &&
  gpg --import-ownertrust --no-tty ownertrust.gpg.key &&
  echo D &&
  docker pull emorymerryman/git:0.0.1 &&
  docker pull emorymerryman/pass:0.5.0 &&
  docker pull emorymerryman/ssh:0.0.1 &&
  true
