#!/bin/bash

set -e

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

configure() {
    BROKER_IP=$(hostname -I | cut -f 1 -d ' ')

    AMQ_ARGS="--role $AMQ_ROLE --name $AMQ_NAME --allow-anonymous --http-host $BROKER_IP --host $BROKER_IP"

    if [ -n "${AMQ_USER}" ] && [ -n "${AMQ_PASSWORD}" ] ; then
        AMQ_ARGS="--user $AMQ_USER --password $AMQ_PASSWORD $AMQ_ARGS"
    fi
    if [ "$AMQ_CLUSTERED" = "true" ]; then
        echo "Broker will be clustered"
        AMQ_ARGS="$AMQ_ARGS --clustered --cluster-user $AMQ_CLUSTER_USER --cluster-password $AMQ_CLUSTER_PASSWORD"
    fi
    if [ "$AMQ_RESET_CONFIG" = "true" ]; then
        AMQ_ARGS="$AMQ_ARGS --force"
    fi
    if [ "$AMQ_EXTRA_ARGS" ]; then
        AMQ_ARGS="$AMQ_ARGS $AMQ_EXTRA_ARGS"
    fi

    #pragma safe AMQ_ARGS
    AMQ_ARGS="${AMQ_ARGS} ${INSTANCE_DIR}"

    PRINT_ARGS="${AMQ_ARGS/--password $AMQ_PASSWORD/--password XXXXX}"
    PRINT_ARGS="${PRINT_ARGS/--user $AMQ_USER/--user XXXXX}"
    PRINT_ARGS="${PRINT_ARGS/--cluster-user $AMQ_CLUSTER_USER/--cluster-user XXXXX}"
    PRINT_ARGS="${PRINT_ARGS/--cluster-password $AMQ_CLUSTER_PASSWORD/--cluster-password XXXXX}"
    PRINT_ARGS="${PRINT_ARGS/--ssl-key-password $AMQ_KEYSTORE_PASSWORD/--ssl-key-password XXXXX}"
    PRINT_ARGS="${PRINT_ARGS/--ssl-trust-password $AMQ_TRUSTSTORE_PASSWORD/--ssl-trust-password XXXXX}"

    echo "Creating Broker with args $PRINT_ARGS"

    # shellcheck disable=SC2086 (wanted word splitting command)
    artemis create ${AMQ_ARGS}
}

if [ ! -f "$INSTANCE_DIR"/etc/broker.xml ] || [ "$AMQ_RESET_CONFIG" = "true" ]; then
    configure
fi

if [ "$1" = 'configure' ]; then
  echo "Configuring Broker ..."
  configure
fi

if [ "$1" = 'artemis-instance-run' ]; then
  echo "Running Broker ..."
  exec "$INSTANCE_DIR"/bin/artemis run
fi

exec "$@"
