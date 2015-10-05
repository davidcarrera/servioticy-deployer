#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


cd $CB_INSTALL_DIR

./bin/couchbase-cli rebalance \
    --cluster $CB_MASTER:8091 \
    --server-add=`hostname -i`:8091 \
    --server-add-username=$CB_USERNAME \
    --server-add-password=$CB_PASSWORD \
    --user=$CB_USERNAME --password=$CB_PASSWORD

cd $ROOT
exit 0

