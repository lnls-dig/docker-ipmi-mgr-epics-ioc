FROM lnls/epics-dist:base-3.15-debian-9

# Needed external module
ENV IPMICOMM_REPO ipmiComm
ENV IPMICOMM_COMMIT LNLS-R4-3-1

ENV IOC_REPO ipmi-mgr-epics-ioc
ENV BOOT_DIR iocIpmiMgr
ENV IOC_COMMIT v0.2.0

RUN git clone https://github.com/lnls-dig/${IPMICOMM_REPO}.git /opt/epics/${IPMICOMM_REPO} && \
    cd /opt/epics/${IPMICOMM_REPO} && \
    git checkout ${IPMICOMM_COMMIT} && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps-lnls-R1-0-0/support' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-R5-9' >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-R3-7' >> configure/RELEASE.local && \
    echo 'STREAM=$(SUPPORT)/stream-R2-7-7' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-R4-33' >> configure/RELEASE.local && \
    echo 'IOCSTATS=$(SUPPORT)/iocStats-3-1-15' >> configure/RELEASE.local && \
    echo 'IOCADMIN=$(SUPPORT)/iocStats-3-1-15' >> configure/RELEASE.local && \
    make && \
    make install && \
    git clone https://github.com/lnls-dig/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${IOC_COMMIT} && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps-lnls-R1-0-0/support' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-R5-9' >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-R3-7' >> configure/RELEASE.local && \
    echo 'STREAM=$(SUPPORT)/stream-R2-7-7' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-R4-33' >> configure/RELEASE.local && \
    echo 'IOCSTATS=$(SUPPORT)/iocStats-3-1-15' >> configure/RELEASE.local && \
    echo 'IPMICOMM=/opt/epics/${IPMICOMM_REPO}' >> configure/RELEASE.local && \
    make && \
    make install

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
