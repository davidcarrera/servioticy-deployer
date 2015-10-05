#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh



echo "Create External Cluster Reference"
echo "--------------------------------------------------------"
# based on http://review.couchbase.org/#/c/27930/

curl -v -u $CB_USERNAME:$CB_PASSWORD $CB_MASTER:8091/pools/default/remoteClusters \
-d name=$ES_CLUSTER_NAME \
-d hostname=$CB_MASTER:9091 \
-d username=$CB_USERNAME -d password=$CB_PASSWORD


echo "Create Links"
echo "--------------------------------------------------------"

curl -v -X POST -u $CB_USERNAME:$CB_PASSWORD http://$CB_MASTER:8091/controller/createReplication \
-d fromBucket=soupdates \
-d toCluster=$ES_CLUSTER_NAME \
-d toBucket=soupdates \
-d replicationType=continuous \
-d type=capi

curl -v -X POST -u $CB_USERNAME:$CB_PASSWORD http://$CB_MASTER:8091/controller/createReplication \
-d fromBucket=subscriptions \
-d toCluster=$ES_CLUSTER_NAME \
-d toBucket=subscriptions \
-d replicationType=continuous \
-d type=capi



exit 0
