#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


cd $CB_INSTALL_DIR

cho "Create buckets"
echo "--------------------------------------------------------"
./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=serviceobjects \
    -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=privatebucket \
     -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=actuations \
     -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=soupdates \
     -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=subscriptions \
     -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

./bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=$CB_BUCKET_RAMSIZE \
    --bucket-replica=$CB_BUCKET_REPLICA \
    --bucket=reputation \
     -c $CB_MASTER --user=$CB_USERNAME --password=$CB_PASSWORD

cd $ROOT
exit 0

