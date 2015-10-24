#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Servioticy"
mkdir -p $SERVIOTICY_INSTALL_DIR
mkdir -p $DISPATCHER_INSTALL_DIR

kafka_head=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA)

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/start_zk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA  "cd $ROOT; $SCRIPTS_FOLDER/start_kafka.sh"
sleep 2
dsh -m $kafka_head "cd $ROOT; ./scripts/create_topics.sh"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA  "cd $ROOT; $SCRIPTS_FOLDER/stop_kafka.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/stop_zk.sh"

cd $FILE_REPOSITORY/servioticy/servioticy-dispatcher

chmod +x ./unmanaged-dependencies.sh
./unmanaged-dependencies.sh

cd $FILE_REPOSITORY/servioticy

kafka_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    kafka_servers="$kafka_servers$line:9092 "
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA"

zk_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    zk_servers="$zk_servers<address>$line:2181</address>"
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

cb_server=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB)

apiurl=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY)

mvn -Dmaven.test.skip=true package

cp ./servioticy-dispatcher/target/$DISPATCHER_JAR $DISPATCHER_INSTALL_DIR/

cat $DISPATCHER_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_DISPATCHER_FEEDBACK%/$kafka_servers/g" | \
perl -pe "s|%PLACEHOLDER_DISPATCHER_ZK%|$zk_servers|g" | \
perl -pe "s/%PLACEHOLDER_DISPATCHER_COUCHBASE%/$cb_server/g" | \
perl -pe "s|%PLACEHOLDER_DISPATCHER_API_URL%|http://$apiurl:8080/|g" > $DISPATCHER_INSTALL_DIR/dispatcher.xml

cd $ROOT
