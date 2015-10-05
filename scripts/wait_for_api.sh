#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

status=`/usr/bin/curl -X GET -s localhost:8080|grep 403| sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`/usr/bin/curl -X GET -s localhost:8080|grep 403| sed 's/ //g'`
done
name=`hostname -i`
echo "API (Jetty) service running in "$name

