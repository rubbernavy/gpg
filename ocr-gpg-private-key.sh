#!/bin/sh

dnf update --assumeyes &&
  dnf install --assumeyes tesseract* &&
  tesseract /root/secret.key.tiff secret.key &&
  dnf install --assumeyes wget &&
  wget &&
  dnf install --assumeyes paperkey &&
  paperkey --pubring= --secret==/root/secret.key.txt --output=/root/secret.key &&
  gpg --import /root/secret.key &&
  gpg2 --import /root/secret.key &&
  true
