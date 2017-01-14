#!/bin/sh

BIN=$(docker volume create) &&
  DOT_PASSWORD_STORE=$(docker volume create) &&
  echo -en '#!/bin/sh\n\n' > docker \
    run \
    --interactive \
    --rm \
    --volume ${BIN}:/usr/local/bin \
    --workdir /usr/local/bin \
    emorymerryman/base:0.7.0 \
    tee pass &&
  true
