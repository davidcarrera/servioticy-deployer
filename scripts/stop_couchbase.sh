#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


echo Stopping Couchbase
cd $CB_INSTALL_DIR;
./bin/couchbase-server -k
echo Done


cd $ROOT
