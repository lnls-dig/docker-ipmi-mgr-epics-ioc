#!/usr/bin/env bash

set -u

if [ -z "$ARAMP_INSTANCE" ]; then
    echo "ARAMP_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    ar-amp-epics-ioc-${ARAMP_INSTANCE}
