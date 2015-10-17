#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

dispatcher_master=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM)

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY  "cd $ROOT; $SCRIPTS_FOLDER/start_security.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/start_elasticsearch.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/wait_for_elasticsearch_up.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/start_couchbase.sh"
$SCRIPTS_FOLDER/wait_for_couchbase_up.sh
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/start_jetty.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/start_zk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA  "cd $ROOT; $SCRIPTS_FOLDER/start_kafka.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM  "cd $ROOT; $SCRIPTS_FOLDER/start_storm.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM  "cd $ROOT; $SCRIPTS_FOLDER/start_mysql.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM  "bash -ic \"cd $ROOT; $SCRIPTS_FOLDER/start_uaa.sh\""
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM  "cd $ROOT; $SCRIPTS_FOLDER/start_idm.sh"
dsh -m $dispatcher_master  "bash -ic \"cd $ROOT; $SCRIPTS_FOLDER/start_dispatcher.sh\""
