#!/bin/sh

volume(){
    docker \
      run \
      --interactive \
      --rm \
      --volume ${@}:/usr/local/src \
      --workdir /usr/local/src \
      emorymerryman/base:0.0.6 \
      chown --recursive user:user . &&
    true
} &&
  inject(){
    PROGRAM=${1} &&
      SBIN=${2} &&
      BIN=${3} &&
      SUDO=${4} &&
      SBIN2=${5} &&
      BIN2=${6} &&
      SUDO2=${7} &&
      WORK=${8} &&
      DOT_GNUPG=${9} &&
      DOT_PASSWORD_STORE=${10} &&
      DOT_SSH=${11} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${SBIN}:/usr/local/sbin \
        --volume /vagrant/injections/sbin:/usr/local/src:ro \
        --workdir /usr/local/src \
        emorymerryman/base:0.0.6 \
        sed \
          -e "s#\${SBIN}#${SBIN2}#" \
          -e "s#\${BIN}#${BIN2}#" \
          -e "s#\${SUDO}#${SUDO2}#" \
          -e "s#\${WORK}#${WORK}#" \
          -e "s#\${DOT_GNUPG}#${DOT_GNUPG}#" \
          -e "s#\${DOT_GNUPG}#${DOT_PASSWORD_STORE}#" \
          -e "s#\${DOT_GNUPG}#${DOT_SSH}#" \
          -e "w/usr/local/sbin/${PROGRAM}" \
          ${PROGRAM}.sh &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${SBIN}:/usr/local/sbin \
        emorymerryman/base:0.0.6 \
        chmod 0500 /usr/local/sbin/${PROGRAM} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${BIN}:/usr/local/bin \
        --volume /vagrant/injections/bin:/usr/local/src:ro \
        --workdir /usr/local/src \
        emorymerryman/base:0.0.6 \
        sed \
          -e "s#\${PROGRAM}#${PROGRAM}#" \
          -e "w/usr/local/bin/${PROGRAM}" \
          bin.sh
      docker \
        run \
        --interactive \
        --rm \
        --volume ${BIN}:/usr/local/bin \
        emorymerryman/base:0.0.6 \
        chmod 0555 /usr/local/bin/${PROGRAM} &&
      echo user ALL = NOPASSWD: /usr/local/sbin/${PRG} | docker \
        run \
        --interactive \
        --rm \
        --volume ${SUDO}:/etc/sudoers.d \
        emorymerryman/base:0.0.6 \
        tee /etc/sudoers.d/${PROGRAM} &&
      docker \
        run \
        --interactive \
        --rm \
        --volume ${SUDO}:/etc/sudoers.d \
        emorymerryman/base:0.0.6 \
        chmod 0444 /etc/sudoers.d/${PROGRAM} &&
      true
  } &&
  BIN=$(docker volume create) &&
  DOT_PASSWORD_STORE=$(docker volume create) &&
  DOT_GNUPG=$(docker volume create) &&
  DOT_SSH=$(docker volume create)
  GIT_BIN=$(docker volume create) &&
  GIT_SBIN=$(docker volume create) &&
  GIT_SUDO=$(docker volume create) &&
  GPG_BIN=$(docker volume create) &&
  GPG_SBIN=$(docker volume create) &&
  GPG_SUDO=$(docker volume create) &&
  PASS_BIN=$(docker volume create) &&
  PASS_SBIN=$(docker volume create) &&
  PASS_SUDO=$(docker volume create) &&
  SBIN=$(docker volume create) &&
  SSH_BIN=$(docker volume create) &&
  SSH_SBIN=$(docker volume create) &&
  SSH_SUDO=$(docker volume create) &&
  TREE_BIN=$(docker volume create) &&
  TREE_SBIN=$(docker volume create) &&
  TREE_SUDO=$(docker volume create) &&
  SUDO=$(docker volume create) &&
  WORK=$(docker volume create) &&
  inject git ${PASS_SBIN} ${PASS_BIN} ${PASS_SUDO} ${GIT_SBIN} ${GIT_BIN} ${GIT_SUDO} ${DOT_PASSWORD_STORE} ${DOT_GNUPG} ${DOT_PASSWORD_STORE} ${DOT_SSH} &&
  inject gpg ${PASS_SBIN} ${PASS_BIN} ${PASS_SUDO} ${GPG_SBIN} ${GPG_BIN} ${GPG_SUDO} ${DOT_PASSWORD_STORE} ${DOT_GNUPG} ${DOT_PASSWORD_STORE} ${DOT_SSH} &&
  inject pass ${SBIN} ${BIN} ${SUDO} ${PASS_SBIN} ${PASS_BIN} ${PASS_SUDO} ${WORK} ${DOT_GNUPG} ${DOT_PASSWORD_STORE} ${DOT_SSH} &&
  inject ssh ${GIT_SBIN} ${GIT_BIN} ${GIT_SUDO} ${SSH_SBIN} ${SSH_BIN} ${SSH_SUDO} ${DOT_PASSWORD_STORE} ${DOT_GNUPG} ${DOT_PASSWORD_STORE} ${DOT_SSH} &&
  inject tree ${PASS_SBIN} ${PASS_BIN} ${PASS_SUDO} ${TREE_SBIN} ${TREE_BIN} ${TREE_SUDO} ${DOT_PASSWORD_STORE} ${DOT_GNUPG} ${DOT_PASSWORD_STORE} ${DOT_SSH} &&
  volume ${BIN} &&
  volume ${DOT_PASSWORD_STORE} &&
  volume ${DOT_GNUPG} &&
  volume ${DOT_SSH} &&
  volume ${GIT_BIN} &&
  volume ${GIT_SBIN} &&
  volume ${GIT_SUDO} &&
  volume ${GPG_BIN} &&
  volume ${GPG_SBIN} &&
  volume ${GPG_SUDO} &&
  volume ${PASS_BIN} &&
  volume ${PASS_SBIN} &&
  volume ${PASS_SUDO} &&
  volume ${SBIN} &&
  volume ${TREE_BIN} &&
  volume ${TREE_SBIN} &&
  volume ${TREE_SUDO} &&
  volume ${SUDO} &&
  volume ${WORK} &&
  gpg(){
    export WORK=/vagrant &&
      export DOT_GNUPG=${DOT_GNUPG} &&
      /usr/bin/sh /vagrant/injections/sbin/gpg.sh ${@} &&
      true
  } &&
  pass(){
    export BIN=${PASS_BIN} &&
      export SBIN=${PASS_SBIN} &&
      export SUDO=${PASS_SUDO} &&
      export DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&
      /usr/bin/sh /vagrant/injections/sbin/pass.sh ${@} &&
      true
  } &&
  git(){
    export BIN=${PASS_BIN} &&
      export SBIN=${PASS_SBIN} &&
      export SUDO=${PASS_SUDO} &&
      export WORK=${DOT_PASSWORD_STORE} &&
      /usr/bin/sh /vagrant/injections/sbin/git.sh ${@} &&
      true
  } &&
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
  docker pull emorymerryman/git:0.0.3 &&
  echo BEFORE .................................. &&
  echo DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&

  volume ${DOT_PASSWORD_STORE} &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${PASS_SBIN}:/usr/local/sbin:ro \
    --volume ${PASS_BIN}:/usr/local/bin:ro \
    --volume ${PASS_SUDO}:/etc/sudoers.d:ro \
    --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
    --user root \
    emorymerryman/base:0.0.6 \
    cat /usr/local/bin/git &&
    docker \
      run \
      --interactive \
      --rm \
      --volume /var/run/docker.sock:/var/run/docker.sock:ro \
      --volume ${PASS_SBIN}:/usr/local/sbin:ro \
      --volume ${PASS_BIN}:/usr/local/bin:ro \
      --volume ${PASS_SUDO}:/etc/sudoers.d:ro \
      --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
      --user root \
      emorymerryman/base:0.0.6 \
      cat /usr/local/sbin/git &&


  LOCAL_GIT=$(mktemp) &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${PASS_SBIN}:/usr/local/sbin:ro \
    --volume ${PASS_BIN}:/usr/local/bin:ro \
    --volume ${PASS_SUDO}:/etc/sudoers.d:ro \
    --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
    --user root \
    emorymerryman/base:0.0.6 \
    cat /usr/local/sbin/git > ${LOCAL_GIT} &&
  chmod 0500 ${LOCAL_GIT} &&
  cat ${LOCAL_GIT} &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${PASS_SBIN}:/usr/local/sbin:ro \
    --volume ${PASS_BIN}:/usr/local/bin:ro \
    --volume ${PASS_SUDO}:/etc/sudoers.d:ro \
    --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
    --user root \
    emorymerryman/base:0.0.6 \
    stat /home/user/.password-store &&
  ${LOCAL_GIT} init &&




  pass init D65D3F8C &&
  echo DOIN STUF ............................... &&
  echo HERE .................................. &&
  echo DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&

  git init &&
  echo DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${PASS_SBIN}:/usr/local/sbin:ro \
    --volume ${PASS_BIN}:/usr/local/bin:ro \
    --volume ${PASS_SUDO}:/etc/sudoers.d:ro \
    --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
    --user root \
    emorymerryman/base:0.0.6 \
    cat /usr/local/sbin/git &&


  pass git init &&
  echo THERE .................................. &&
  pass git config user.name "Emory Merryman" &&
  pass git config user.email "emory.merryman+$(uuidgen)@gmail.com" &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  pass show &&
  docker pull emorymerryman/pass:0.6.0 &&
  docker pull emorymerryman/ssh:0.0.1 &&
  docker pull emorymerryman/tree:0.0.2 &&
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
