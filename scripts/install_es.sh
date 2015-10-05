#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$ES_FILE
folder=`ls -1 | grep elasticsearch- | head -1`
ln -s $folder $ES_INSTALL_DIR

nodes=`cat $MACHINE_FILES_FOLDER/$MACHINE_FILE_ES | perl -pe "s/\n/\",/g" | perl -pe "s/^/\"/g" | perl -pe "s/,$//g" | perl -pe "s/,/,\"/g"`
nodename=`hostname -f`

mkdir -p $ES_DATA_DIR
mkdir -p $ES_LOG_DIR

data_dir=`echo $ES_DATA_DIR | sed -e 's/\//\\\\\\//g'`
log_dir=`echo $ES_LOG_DIR | sed -e 's/\//\\\\\\//g'`

cat $ES_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_HOSTNAME%/$nodename/g" | \
perl -pe "s/%PLACEHOLDER_NODE_NAMES%/$nodes/g" | \
perl -pe "s/%PLACEHOLDER_ES_CLUSTER_NAME%/$ES_CLUSTER_NAME/g" | \
perl -pe "s/%PLACEHOLDER_CB_USERNAME%/$CB_USERNAME/g" | \
perl -pe "s/%PLACEHOLDER_CB_PASSWORD%/$CB_PASSWORD/g" | \
perl -pe "s/%PLACEHOLDER_ES_LOG_DIR%/$log_dir/g" | \
perl -pe "s/%PLACEHOLDER_ES_DATA_DIR%/$data_dir/g" > $ES_INSTALL_DIR/config/elasticsearch.yml

cd $ROOT
