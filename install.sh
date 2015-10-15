#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/install_cb.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM "cd $ROOT; $SCRIPTS_FOLDER/install_pdp.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/install_jetty.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY "cd $ROOT; $SCRIPTS_FOLDER/install_pdp.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/install_es.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/install_cb_es_transport.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/start_elasticsearch.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/wait_for_elasticsearch_up.sh"
$SCRIPTS_FOLDER/create_index.sh

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/start_couchbase.sh"
$SCRIPTS_FOLDER/wait_for_couchbase.sh
ssh $CB_MASTER "cd $SCRIPTS_FOLDER; sh initialize_cb.sh" #&> /dev/null
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/cb_add_node.sh"
ssh $CB_MASTER "cd $SCRIPTS_FOLDER; sh create_buckets.sh" #&> /dev/null
$SCRIPTS_FOLDER/wait_for_couchbase_up.sh

$SCRIPTS_FOLDER/create_views.sh #&> /dev/null
$SCRIPTS_FOLDER/create_xdcr.sh #&> /dev/null


dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK "mkdir -p $ZK_DATA_DIR"
zkserversconf=""
servercount=1
while IFS='' read -r line || [[ -n "$line" ]]; do
    dsh -m $line "echo $servercount > $ZK_DATA_DIR/myid"
    servercount=$((servercount+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/install_zk.sh"

servercount=1
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA "mkdir -p $SERVIOTICY_INSTALL_DIR"
while IFS='' read -r line || [[ -n "$line" ]]; do
    dsh -m $line "echo $servercount > $SERVIOTICY_INSTALL_DIR/kafkaid"
    servercount=$((servercount+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA "cd $ROOT; $SCRIPTS_FOLDER/install_kafka.sh"

numservers=0
servercount=1
while IFS='' read -r line || [[ -n "$line" ]]; do
    numservers=$((numservers+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM "mkdir -p $SERVIOTICY_INSTALL_DIR"
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ "$servercount" -eq 1 ]
        then
            dsh -m $line "touch $SERVIOTICY_INSTALL_DIR/storm_nimbus"
    fi
    if [ "$numservers" -eq "$servercount" ]
        then
        dsh -m $line "touch $SERVIOTICY_INSTALL_DIR/storm_supervisor"
    fi
    if [ "$servercount" -ne 1 ]
        then
        dsh -m $line "touch $SERVIOTICY_INSTALL_DIR/storm_supervisor"
    fi
    servercount=$((servercount+1))
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM "cd $ROOT; $SCRIPTS_FOLDER/install_storm.sh"

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY "cd $ROOT; $SCRIPTS_FOLDER/install_nodejs.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY "bash -ic \"cd $ROOT; $SCRIPTS_FOLDER/install_security.sh\""
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM "cd $ROOT; $SCRIPTS_FOLDER/install_mysql.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM "cd $ROOT; $SCRIPTS_FOLDER/install_uaa.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM "bash -ic \"cd $ROOT; $SCRIPTS_FOLDER/install_idm.sh\""

