#!/bin/sh
# Installs the AMQ distribution into the filesystem.
set -e

SOURCES_DIR=/tmp/artifacts
SCRIPT_DIR=$(dirname $0)

DISTRIBUTION_VERSION="${DISTRIBUTION_PREFIX}-${ARTEMIS_VERSION}"
DISTRIBUTION_PATH="/opt/${DISTRIBUTION_VERSION}"

BIN_PACKAGE="${DISTRIBUTION_VERSION}-bin.zip"
BIN_PATH="${SOURCES_DIR}/${BIN_PACKAGE}"

unzip -q "${BIN_PATH}" -d /opt
chmod 755 $DISTRIBUTION_PATH

ln -s $DISTRIBUTION_PATH $ARTEMIS_DIR
ln -s $ARTEMIS_DIR/bin/artemis /usr/local/bin

# Artemis user
groupadd -g 185 ${ARTEMIS_USER}
useradd -u 185 -l -M -g ${ARTEMIS_USER} -s /sbin/nologin ${ARTEMIS_USER}

mkdir -p $INSTANCE_DIR
chown -R ${ARTEMIS_USER}.${ARTEMIS_USER} $INSTANCE_DIR
chmod -R ug+srwX $INSTANCE_DIR

cp ${SCRIPT_DIR}/launch.sh /
