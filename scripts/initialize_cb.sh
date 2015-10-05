#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


cd $CB_INSTALL_DIR

echo "Node initialization"
sleep 10
echo "--------------------------------------------------------"
./bin/couchbase-cli node-init \
    -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD \
    --node-init-data-path=$CB_DATA_DIR

sleep 5
echo "Instance initialization"
echo "--------------------------------------------------------"
./bin/couchbase-cli cluster-init \
    -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD \
    --cluster-init-username=$CB_USERNAME \
    --cluster-init-password=$CB_PASSWORD \
    --cluster-init-ramsize=$CB_INIT_RAMSIZE
sleep 5


cd $ROOT
exit 0

