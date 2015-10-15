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
cd $FILE_REPOSITORY/servioticy

kafka_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    $kafka_servers="$kafka_servers$line:9092 "
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA"

zk_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    $zk_servers="$zk_servers<address>$line:2181</address>"
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

cb_server=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_COUCHBASE)

apiurl=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY)

numservers=0
cb_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    numservers=$((numservers+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_CB"

while IFS='' read -r line || [[ -n "$line" ]]; do
    cb_servers="$cb_servers$line"
    if [ "$numservers" -ne  "$servercount" ]
        then
            servercount=$((servercount+1))
            cb_servers="$cb_servers,"
    fi
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_CB"

numservers=0
es_servers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    numservers=$((numservers+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ES"

while IFS='' read -r line || [[ -n "$line" ]]; do
    es_servers="$es_servers$line"
    if [ "$numservers" -ne "$servercount" ]
        then
            servercount=$((servercount+1))
            es_servers="$es_servers,"
    fi
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ES"

idm_url=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM)

cat $API_CONFIG_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_API_COUCHBASE%/$cb_servers/g" | \
perl -pe "s/%PLACEHOLDER_API_ELASTICSEARCH%/$es_servers/g" | \
perl -pe "s/%PLACEHOLDER_API_IDM_HOST%/$idm_url/g" > ./servioticy-api-private/src/main/resources/config.properties

cp ./servioticy-api-private/src/main/resources/config.properties ./servioticy-api-public/src/main/resources/config.properties

cat $API_UPDATES_QUEUE_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_DISPATCHER_FEEDBACK%/$kafka_servers/g" > ./servioticy-api-public/src/main/resources/default.xml

mvn -Dmaven.test.skip=true package

cp ./servioticy-api-public/target/api-public.war $JETTY_INSTALL_DIR/webapps/root.war
cp ./servioticy-api-private/target/api-private.war $JETTY_INSTALL_DIR/webapps/private.war

cp ./servioticy-dispatcher/target/$DISPATCHER_JAR $DISPATCHER_INSTALL_DIR/

cat $DISPATCHER_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_DISPATCHER_FEEDBACK%/$kafka_servers/g" | \
perl -pe "s|%PLACEHOLDER_DISPATCHER_ZK%|$zk_servers|g" | \
perl -pe "s/%PLACEHOLDER_DISPATCHER_COUCHBASE%/$cb_server/g" | \
perl -pe "s|%PLACEHOLDER_DISPATCHER_API_URL%|http://$apiurl:8080/|g" > $DISPATCHER_INSTALL_DIR/dispatcher.xml

cd $ROOT


