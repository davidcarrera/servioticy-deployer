#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $ZK_INSTALL_DIR
./bin/zkServer.sh start
cd $ROOT

exit 0