#!/bin/sh

COMMIT_ID=$(git rev-parse --verify HEAD) &&
  WORK_DIR=$(mktemp -d) &&
  vagrant destroy -f &&
  vagrant provision &&
  vagrant up &&
  sleep 30s &&
  vagrant halt &&
  vagrant up &&
  sleep 30s &&
  vagrant halt &&
  vagrant up &&
  sleep 30s &&
  vagrant halt &&
  vagrant package --output ${WORK_DIR}/gpg.${COMMIT_ID}.box &&
  vagrant box add --name gpg.${COMMIT_ID} ${WORK_DIR}/gpg.${COMMIT_ID}.box &&
  vagrant halt &&
  rm -rf ${WORK_DIR} &&
  vagrant destroy -f &&
  true
