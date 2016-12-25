#!/bin/sh

dnf update --assumeyes &&
  dnf install --assumeyes gnupg gnupg2 &&
  gpg --import /root/public.key &&
  gpg2 --import /root/public.key &&
  gpg --import /root/private.key &&
  gpg2 --import /root/private.key &&
  gpg --import-ownertrust /root/owner.trust &&
  gpg2 --import-ownertrust /root/owner.trust &&
  true
