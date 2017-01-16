#!/bin/sh

export DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&
  export DOT_GNUPG=${DOT_GNUPG} &&
  docker \
    run \
    --interactive \
    --rm \
    --volume ${DOT_PASSWORD_STORE}:/root/.password-store \
    --volume ${DOT_GNUPG}:/root/.gnupg \
    --volume ${DOT_SSH}:/root/.ssh \
    --user user \
    emorymerryman/pass:0.8.3 \
    ${@} &&
  true
