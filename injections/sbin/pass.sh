#!/bin/sh

export DOT_PASSWORD_STORE=${DOT_PASSWORD_STORE} &&
  export DOT_GNUPG=${DOT_GNUPG} &&
  docker \
    run \
    --interactive \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${DOT_PASSWORD_STORE}:/home/user/.password-store \
    --env DOT_PASSWORD_STORE \
    --env DOT_GNUPG \
    --user user \
    emorymerryman/pass:0.7.6 \
    ${@} &&
  true
