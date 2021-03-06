#!/bin/sh

DOT_GNUPG=$(docker volume create --name dot_gnupg) &&
dnf update --assumeyes &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /vagrant/create_dot_gnupg_volume.sh:/root/bin/create_dot_gnupg_volume.sh:ro \
    --volume /vagrant/secret.key:/root/secret.key:ro \
    --volume /vagrant/owner.trust:/root/owner.trust:ro \
    --volume ${DOT_GNUPG}:/root/.ssh \
    --workdir /root \
    fedora:25 \
    sh /root/bin/create_dot_gnupg_volume.sh &&
  dnf update --assumeyes &&
  dnf clean all &&
  true
