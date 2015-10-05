#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


echo Starting CouchBase...
cd $CB_INSTALL_DIR
./bin/couchbase-server -- -noinput -detached
echo Done

cd $ROOT
