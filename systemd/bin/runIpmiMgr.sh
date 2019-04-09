#!/usr/bin/env bash

set -u

if [ -z "$IPMIMGR_INSTANCE" ]; then
    echo "IPMIMGR_INSTANCE environment variable is not set." >&2
    exit 1
fi

export IPMIMGR_CURRENT_PV_AREA_PREFIX=IPMIMGR_${IPMIMGR_INSTANCE}_PV_AREA_PREFIX
export IPMIMGR_CURRENT_PV_DEVICE_PREFIX=IPMIMGR_${IPMIMGR_INSTANCE}_PV_DEVICE_PREFIX
export IPMIMGR_CURRENT_DEVICE_IP=IPMIMGR_${IPMIMGR_INSTANCE}_DEVICE_IP
export IPMIMGR_CURRENT_TELNET_PORT=IPMIMGR_${IPMIMGR_INSTANCE}_TELNET_PORT
# Only works with bash
export IPMIMGR_PV_AREA_PREFIX=${!IPMIMGR_CURRENT_PV_AREA_PREFIX}
export IPMIMGR_PV_DEVICE_PREFIX=${!IPMIMGR_CURRENT_PV_DEVICE_PREFIX}
export IPMIMGR_DEVICE_IP=${!IPMIMGR_CURRENT_DEVICE_IP}
export IPMIMGR_TELNET_PORT=${!IPMIMGR_CURRENT_TELNET_PORT}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/ipmi-mgr-epics-ioc/iocBoot/iocIpmiMgr/autosave \
    --name ipmi-mgr-epics-ioc-${IPMIMGR_INSTANCE}-volume \
    lnlsdig/ipmi-mgr-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    ipmi-mgr-epics-ioc-${IPMIMGR_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from ipmi-mgr-epics-ioc-${IPMIMGR_INSTANCE}-volume \
    --name ipmi-mgr-epics-ioc-${IPMIMGR_INSTANCE} \
    lnlsdig/ipmi-mgr-epics-ioc:${IMAGE_VERSION} \
    -t "${IPMIMGR_TELNET_PORT}" \
    -i "${IPMIMGR_DEVICE_IP}" \
    -P "${IPMIMGR_PV_AREA_PREFIX}" \
    -R "${IPMIMGR_PV_DEVICE_PREFIX}"
