#!/bin/sh

echo "XxXXXXXXX 2000" &&
inject(){
  PROGRAM=${1} &&
    ROOT_BIN_DIR=${2} &&
    SRC_DIR=${3} &&
    USR_BIN_DIR=${4} &&
    SUDO_DIR=${5} &&
    DOT_SSH=${6} &&
    DOT_GNUPG=${7} &&
    PASS_STORE=${8} &&
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
      chmod 0500 /root/bin/${PROGRAM} &&
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
  echo "XxXXXXXXX 2010" &&
  echo "XxXXXXXXX 2011" &&
  echo "XxXXXXXXX 2012" &&
  echo "XxXXXXXXX 2013" &&
  PASS_STORE=$(docker volume create) &&
  echo "XxXXXXXXX 2020" &&
  BIN=$(docker volume create --name bin) &&
  echo "XxXXXXXXX 2030" &&
  export DOT_GNUPG=$(docker volume create) &&
  echo "XxXXXXXXX 2040" &&
  export DOT_SSH=$(docker volume create) &&
  echo "XxXXXXXXX 2050" &&
  GIT_BIN_DIR=$(docker volume create) &&
  echo "XxXXXXXXX 2060" &&
  GIT_SUDO_DIR=$(docker volume create) &&
  echo "XxXXXXXXX 2070" &&
  PASS_BIN_DIR=$(docker volume create) &&
  echo "XxXXXXXXX 2080" &&
  PASS_SUDO_DIR=$(docker volume create) &&
  echo "XxXXXXXXX 3000" &&
  echo "XxXXXXXXX 4000" &&
  inject gpg ${PASS_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject ssh ${GIT_BIN_DIR} ${PASS_STORE} $(docker volume create) $(docker volume create) ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject git ${PASS_BIN_DIR} ${PASS_STORE} ${GIT_BIN_DIR} ${GIT_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
  inject pass ${BIN} ${PASS_STORE} ${PASS_BIN_DIR} ${PASS_SUDO_DIR} ${DOT_SSH} ${DOT_GNUPG} ${PASS_STORE} &&
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
    emorymerryman/base:0.0.6 \
    chown user:user /usr/local/src &&
  echo allow-loopback-pinentry | docker \
    run \
    --interactive \
    --rm \
    --volume ${DOT_GNUPG}:/usr/local/src \
    emorymerryman/base:0.0.6 \
    tee -a /usr/local/src/gpg-agent.conf &&
  gpg --import --no-tty public.gpg.key &&
  gpg --import --batch --no-tty private.gpg.key &&
  gpg --import-ownertrust --no-tty ownertrust.gpg.key &&
  docker pull emorymerryman/git:0.0.1 &&
  docker pull emorymerryman/pass:0.6.0 &&
  docker pull emorymerryman/ssh:0.0.1 &&
  mkdir /home/vagrant/bin &&
  sed \
    -e "s#\${USR_BIN_DIR}#${PASS_BIN_DIR}#" \
    -e "s#\${SUDO_DIR}#${PASS_SUDO_DIR}#" \
    -e "s#\${DOT_SSH}#${DOT_SSH}#" \
    -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
    -e "s#\${PASS_STORE}#${PASS_STORE}#" \
    -e "w/usr/local/bin/pass" \
    /vagrant/injections/pass.sh &&
  chmod 0500 /usr/local/bin/pass &&
  chmod a+rx /usr/local/bin/pass &&
  true
