#!/bin/sh

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

export BROKER_IP=`hostname -I | cut -f 1 -d ' '`


function configure() {
    local instanceDir=$1
    local instanceId=$2
    export CONTAINER_ID=$HOSTNAME
    if [ ! -d "$INSTANCE" ]; then
        $AMQ_HOME/bin/artemis create broker --user $AMQ_USER --password $AMQ_PASSWORD --role $AMQ_ROLE --name $AMQ_NAME --allow-anonymous --http-host $BROKER_IP --host $BROKER_IP --java-options "$JAVA_OPTS"
    fi

}

function runServer() {
  configure
  echo "Running instance $instanceId"
  exec ~/broker/bin/artemis run
}

runServer
