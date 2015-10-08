#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Zookeeper"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$ZK_FILE
folder=`ls -1 | grep zookeeper | head -1`
ln -s $folder $ZK_INSTALL_DIR

zkserversconf=""
servercount=1
while IFS='' read -r line || [[ -n "$line" ]]; do
    zkserversconf="$zkserversconf\nserver.$servercount=$line:2888:3888"
    servercount=servercount + 1
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

cat $ZK_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_ZK_SERVERS%/$zkserversconf/g" | \
perl -pe "s/%PLACEHOLDER_ZK_DATA_DIR%/$ZK_DATA_DIR/g" > $ZK_INSTALL_DIR/conf/zoo.cfg

cd $ROOT