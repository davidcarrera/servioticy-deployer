#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo Waiting for CouchBase to start
rm -f $CB_STATUS_FILE
curl -s -X GET http://$CB_MASTER:8091/pools  > $CB_STATUS_FILE
status=`grep -s pools $CB_STATUS_FILE | sed 's/ //g' | tail -1`
while [ -z $status ]
do
	sleep 1
	curl -s -X GET http://$CB_MASTER:8091/pools  > $CB_STATUS_FILE
	status=`grep -s pools $CB_STATUS_FILE | sed 's/ //g' | tail -1`
done
rm -f $CB_STATUS_FILE
echo CouchBase Started
