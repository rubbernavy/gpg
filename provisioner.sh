#!/bin/sh

dnf update --assumeyes &&
  dnf install --assumeyes git xclip pwgen curl wget &&
  WORK_DIR=$(mktemp -d) &&
  git -C ${WORK_DIR} init &&
  git -C ${WORK_DIR} remote add origin https://github.com/furiousfox/password-store.git &&
  git -C ${WORK_DIR} fetch origin &&
  git -C ${WORK_DIR} checkout tags/1.6.5 &&
  make --directory ${WORK_DIR} install &&
  su --login vagrant --command "/usr/bin/sh /vagrant/vagrant.sh" &&
  wget --output-document ${WORK_DIR}/atom.x86_64.rpm https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm &&
  dnf install ${WORK_DIR}/atom.x86_64.rpm &&
  rm --recursive --force ${WORK_DIR} &&
  dnf update --assumeyes &&
  true
