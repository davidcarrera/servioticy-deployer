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

servercount=1
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
            cb_servers="$cb_servers;"
    fi
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_CB"

servercount=1
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

cd $ROOT
