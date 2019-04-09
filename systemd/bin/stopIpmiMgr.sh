#!/usr/bin/env bash

set -u

if [ -z "$IPMIMGR_INSTANCE" ]; then
    echo "IPMIMGR_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    ipmi-mgr-epics-ioc-${IPMIMGR_INSTANCE}
