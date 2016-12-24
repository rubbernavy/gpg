#!/bin/sh

DOT_GNUPG=$(docker volume create) &&
dnf update --assumeyes &&
  docker \
    run \
    --interactive \
    --tty \
    --rm \
    --volume ocr-gpg-private-key.sh:/root/bin/ocr-gpg-private-key.sh:ro \
    --volume /vagrant/secret.key.tiff:/root/secret.key.tiff:ro \
    --volume ${DOT_GNUPG}:/root/.ssh \
    fedora:25 \
    sh /root/bin/ocr-gpg-private-key.sh) &&
  dnf update --assumeyes &&
  dnf clean all &&
  true
