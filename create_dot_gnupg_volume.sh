#!/bin/sh

volume(){
  VOLUME=$(docker volume create) &&
    docker \
      run \
      --interactive \
      --rm \
      --volume ${VOLUME}:/usr/local/src \
      --workdir /usr/local/src \
      emorymerryman/base:0.0.6 \
      chown user:user . &&
    echo ${VOLUME} &&
    true
} &&
  inject(){
    PROGRAM=${1} &&
      ROOT_BIN_DIR=${2} &&
      SRC_DIR=${3} &&
      USR_BIN_DIR=${4} &&
      SUDO_DIR=${5} &&
      DOT_SSH=${6} &&
      DOT_GNUPG=${7} &&
      PASS_STORE=${8} &&
      echo PROGRAM=${PROGRAM} ROOT_BIN_DIR=${ROOT_BIN_DIR} SRC_DIR=${SRC_DIR} USR_BIN_DIR=${USR_BIN_DIR} SUDO_DIR=${SUDO_DIR} DOT_SSH=${DOT_SSH} DOT_GNUPG=${DOT_GNUPG} PASS_STORE=${PASS_STORE} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${ROOT_BIN_DIR}:/root/bin \
        --volume /vagrant/injections:/usr/local/src:ro \
        emorymerryman/base:0.0.6 \
        sed \
          -e "s#\${SRC_DIR}#${SRC_DIR}#" \
          -e "s#\${USR_BIN_DIR}#${USR_BIN_DIR}#" \
          -e "s#\${SUDO_DIR}#${SUDO_DIR}#" \
          -e "s#\${DOT_SSH}#${DOT_SSH}#" \
          -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
          -e "s#\${PASS_STORE}#${PASS_STORE}#" \
          -e "w/root/bin/${PROGRAM}" \
          /usr/local/src/${PROGRAM}.sh &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${ROOT_BIN_DIR}:/root/bin \
        emorymerryman/base:0.0.6 \
        chmod 0555 /root/bin/${PROGRAM} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${USR_BIN_DIR}:/usr/local/bin:ro \
        emorymerryman/base:0.0.6 \
        ls -1 /usr/local/bin | while read PRG
        do
          echo user ALL = NOPASSWD: /usr/local/bin/${PRG} |
          docker \
            run \
            --interactive \
            --rm \
            --volume ${SUDO_DIR}:/etc/sudoers.d \
            emorymerryman/base:0.0.6 \
            tee /etc/sudoers.d/${PRG} &&
          true
        done &&
      true
  } &&
  PASS_STORE=$(volume) &&
  BIN=$(volume) &&
  DOT_GNUPG=$(volume) &&
  DOT_SSH=$(volume) &&
  GIT_BIN_DIR=$(volume) &&
  GIT_SUDO_DIR=$(volume) &&
  PASS_BIN_DIR=$(volume) &&
  PASS_SUDO_DIR=$(volume) &&
  gpg(){
    export SRC_DIR=/vagrant &&
      export DOT_GNUPG=${DOT_GNUPG} &&
      /usr/bin/sh /vagrant/injections/gpg.sh ${@} &&
      true
  } &&
  pass(){
    export USR_BIN_DIR=${PASS_BIN_DIR} &&
      export SUDO_DIR=${PASS_SUDO_DIR} &&
      export PASS_STORE=${PASS_STORE} &&
      /usr/bin/sh /vagrant/injections/pass.sh ${@} &&
      true
  } &&
  inject gpg ${PASS_BIN_DIR} ${PASS_STORE} $(volume) $(volume) ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject tree ${PASS_BIN_DIR} ${PASS_STORE} $(volume) $(volume) ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject ssh ${GIT_BIN_DIR} ${PASS_STORE} $(volume) $(volume) ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject git ${PASS_BIN_DIR} ${PASS_STORE} ${GIT_BIN_DIR} ${GIT_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject pass ${BIN} ${PASS_STORE} ${PASS_BIN_DIR} ${PASS_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&

    echo allow-loopback-pinentry | docker \
      run \
      --interactive \
      --rm \
      --volume ${DOT_GNUPG}:/usr/local/src \
      --user user \
      emorymerryman/base:0.0.6 \
      tee -a /usr/local/src/gpg-agent.conf &&
  gpg --import --no-tty public.gpg.key &&
  gpg --import --batch --no-tty private.gpg.key &&
  gpg --import-ownertrust --no-tty ownertrust.gpg.key &&
  (gpg --list-keys || true) &&
  echo 10010 &&
  pass init D65D3F8C &&
  echo 10020 &&
  ( pass git init || git init ) &&
  echo 10030 &&
  pass git config user.name "Emory Merryman" &&
  echo 10040 &&
  pass git config user.email "emory.merryman+$(uuidgen)@gmail.com" &&
  echo 10050 &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  echo 10060 &&
  pass git fetch origin master &&
  echo 10070 &&
  pass git checkout origin/master &&
  echo 10080 &&
  pass show &&
  echo 10090 &&
  echo AFTER &&
  docker pull emorymerryman/pass:0.6.0 &&
#  docker pull emorymerryman/ssh:0.0.1 &&
#  docker pull emorymerryman/tree:0.0.2 &&
  sed \
    -e "s#\${USR_BIN_DIR}#${PASS_BIN_DIR}#" \
    -e "s#\${SUDO_DIR}#${PASS_SUDO_DIR}#" \
    -e "s#\${DOT_SSH}#${DOT_SSH}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    -e "s#\${PASS_STORE}#${PASS_STORE}#" \
    -e "w/usr/local/bin/pass" \
    /vagrant/injections/pass.sh &&
  chmod 0555 /usr/local/bin/pass &&
  sed \
    -e "s#\${USR_BIN_DIR}#${PASS_BIN_DIR}#" \
    -e "s#\${SUDO_DIR}#${PASS_SUDO_DIR}#" \
    -e "s#\${DOT_SSH}#${DOT_SSH}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    -e "s#\${SRC_DIR}#${DOT_GNUPG}#" \
    -e "s#\${PASS_STORE}#${PASS_STORE}#" \
    -e "w/usr/local/bin/gpg" \
    /vagrant/injections/gpg.sh &&
  chmod 0555 /usr/local/bin/gpg &&
  true
