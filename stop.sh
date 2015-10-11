if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_IDM  "cd $ROOT; $SCRIPTS_FOLDER/stop_idm.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY  "cd $ROOT; $SCRIPTS_FOLDER/stop_security.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM  "cd $ROOT; $SCRIPTS_FOLDER/stop_storm.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_KAFKA  "cd $ROOT; $SCRIPTS_FOLDER/stop_kafka.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/stop_zk.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/stop_jetty.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/stop_elasticsearch.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/stop_couchbase.sh"



