#!/bin/sh

ssh-keygen -f ${HOME}/.ssh/id_rsa -P "" &&
  curl \
  -H "Authorization: token $(cat /vagrant/github.oauth.token)" \
  --request POST --data "{title: \"Vagrant $(uuidgen)\", key: \"$(cat ${HOME}/.ssh/id_rsa.pub)\"}" \
  https://api.github.com/user/keys &&
  gpg --import /vagrant/private.gpg.key &&
  gpg --import /vagrant/public.gpg.key &&
  gpg --import-ownertrust /vagrant/ownertrust.gpg.key &&
  ( gpg --list-keys || echo WTF ) &&
  pass init D65D3F8C &&
  pass git init &&
  pass git remote add origin https://github.com/desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout origin/master &&
  pass show &&
  true
