#!/usr/bin/env bash

set -u

if [ -z "$ARAMP_INSTANCE" ]; then
    echo "ARAMP_INSTANCE environment variable is not set." >&2
    exit 1
fi

export ARAMP_CURRENT_PV_AREA_PREFIX=ARAMP_${ARAMP_INSTANCE}_PV_AREA_PREFIX
export ARAMP_CURRENT_PV_DEVICE_PREFIX=ARAMP_${ARAMP_INSTANCE}_PV_DEVICE_PREFIX
export ARAMP_CURRENT_DEVICE_IP=ARAMP_${ARAMP_INSTANCE}_DEVICE_IP
export ARAMP_CURRENT_DEVICE_PORT=ARAMP_${ARAMP_INSTANCE}_DEVICE_PORT
export ARAMP_CURRENT_TELNET_PORT=ARAMP_${ARAMP_INSTANCE}_TELNET_PORT
# Only works with bash
export ARAMP_PV_AREA_PREFIX=${!ARAMP_CURRENT_PV_AREA_PREFIX}
export ARAMP_PV_DEVICE_PREFIX=${!ARAMP_CURRENT_PV_DEVICE_PREFIX}
export ARAMP_DEVICE_IP=${!ARAMP_CURRENT_DEVICE_IP}
export ARAMP_DEVICE_PORT=${!ARAMP_CURRENT_DEVICE_PORT}
export ARAMP_TELNET_PORT=${!ARAMP_CURRENT_TELNET_PORT}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/ar-amp-epics-ioc/iocBoot/iocARAmp/autosave \
    --name ar-amp-epics-ioc-${ARAMP_INSTANCE}-volume \
    lnlsdig/ar-amp-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    ar-amp-epics-ioc-${ARAMP_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from ar-amp-epics-ioc-${ARAMP_INSTANCE}-volume \
    --name ar-amp-epics-ioc-${ARAMP_INSTANCE} \
    lnlsdig/ar-amp-epics-ioc:${IMAGE_VERSION} \
    -t "${ARAMP_TELNET_PORT}" \
    -i "${ARAMP_DEVICE_IP}" \
    -p "${ARAMP_DEVICE_PORT}" \
    -P "${ARAMP_PV_AREA_PREFIX}" \
    -R "${ARAMP_PV_DEVICE_PREFIX}"
