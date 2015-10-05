if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/install_jetty.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "cd $ROOT; $SCRIPTS_FOLDER/install_cb.sh"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES  "cd $ROOT; $SCRIPTS_FOLDER/install_jdk.sh"
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

dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY  "cd $ROOT; $SCRIPTS_FOLDER/start_jetty.sh" 
