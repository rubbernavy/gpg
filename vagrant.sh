#!/bin/sh

ssh-keygen -f /home/vagrant/.ssh/id_rsa -P "" &&
  curl \
  -H "Authorization: token $(cat /vagrant/github.oauth.token)" \
  --request POST \
  --data "{\"title\": \"Vagrant $(uuidgen)\", \"key\": \"$(cat /home/vagrant/.ssh/id_rsa.pub)\"}" \
  cat /vagrant/config > /home/vagrant/.ssh/config &&
  chmod 0600 /home/vagrant/.ssh/config &&
  https://api.github.com/user/keys &&
  gpg --import /vagrant/private.gpg.key &&
  gpg --import /vagrant/public.gpg.key &&
  gpg --import-ownertrust /vagrant/ownertrust.gpg.key &&
  ( gpg --list-keys || echo WTF ) &&
  pass init D65D3F8C &&
  pass git init &&
  pass git remote add origin git@github.com:desertedscorpion/passwordstore.git &&
  pass git fetch origin master &&
  pass git checkout master &&
  cat /vagrant/post-commit.sh > /home/vagrant/.password-store/.git/hooks/post-commit &&
  chmod 0500 /home/vagrant/.password-store/.git/hooks/post-commit &&
  pass show &&
  true
