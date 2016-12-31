#!/bin/sh

/bin/sh /vagrant/create_dot_gnupg_volume.sh &&
  systemctl disable sshd.service &&
  true
