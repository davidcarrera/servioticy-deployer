#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


#create views for service objects

cd $SCRIPTS_FOLDER

count=$(curl -s -X GET -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/user | grep map | wc -l)
while [ $count -lt 1 ]
do
	echo "    Attempting to create user view"
	curl -s -X PUT -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/user -d @byUser.ddoc &> /dev/null
	count=$(curl -s -X GET -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/user | grep map | wc -l)
done

count=$(curl -s -X GET -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/index | grep map | wc -l)
while [ $count -lt 1 ]
do
	echo "    Attempting to create index view"
	curl -s -X PUT -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/index -d @byIndex.ddoc &> /dev/null
	count=$(curl -s -X GET -H "Content-Type: application/json" http://admin:password@$CB_MASTER:8092/serviceobjects/_design/index | grep map | wc -l)
done

cd $ROOT

exit 0
