if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/start_elasticsearch.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/wait_for_elasticsearch_up.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/start_couchbase.sh"
$SCRIPTS_FOLDER/wait_for_couchbase_up.sh
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/start_jetty.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK  "cd $ROOT; $SCRIPTS_FOLDER/start_zk.sh"




