#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $KAFKA_INSTALL_DIR
./bin/kafka-server-start.sh -daemon ../config/server.properties
cd $ROOT

exit 0