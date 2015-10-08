#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Kafka"
mkdir -p $SERVIOTICY_INSTALL_DIR
mkdir -p $SERVIOTICY_INSTALL_DIR/kafka_logs
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$KAFKA_FILE
folder=`ls -1 | grep kafka | head -1`
ln -s $folder $KAFKA_INSTALL_DIR

zkservers=""
numservers=0
servercount=1

while IFS='' read -r line || [[ -n "$line" ]]; do
    numservers=$((numservers+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"


while IFS='' read -r line || [[ -n "$line" ]]; do
    zkservers="$zkservers$line:2181"
    if [ "$numservers" -ne  "$servercount" ]
        then
            servercount=$((servercount+1))
            zkservers="$zkservers,"
    fi
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

cat $KAFKA_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_KAFKA_BROKER_ID%/$HOSTNAME/g" | \
perl -pe "s/%PLACEHOLDER_KAFKA_ZK_SERVERS%/$zkservers/g" | \
perl -pe "s|%PLACEHOLDER_KAFKA_LOG_DIR%|$SERVIOTICY_INSTALL_DIR/kafka_logs|g" > $KAFKA_INSTALL_DIR/config/server.properties

cd $ROOT