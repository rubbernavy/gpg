#!/bin/sh

dnf update --assumeyes &&
  dnf install --assumeyes gnupg gnupg2 &&
  gpg --import /root/secret.key &&
  gpg2 --import /root/secret.key &&
  gpg --import-ownertrust /root/owner.trust &&
  gpg2 --import-ownertrust /root/owner.trust &&
  true
