#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Storm"
mkdir -p $SERVIOTICY_INSTALL_DIR
mkdir -p $SERVIOTICY_INSTALL_DIR/storm_data
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$STORM_FILE
folder=`ls -1 | grep storm | head -1`
ln -s $folder $STORM_INSTALL_DIR

zkservers=""
while IFS='' read -r line || [[ -n "$line" ]]; do
    zkservers="$zkservers  - $line\n"
done < "$MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK"

nimbushost=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_STORM)

cat $STORM_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_STORM_ZK_SERVERS%/$zkservers/g" | \
perl -pe "s/%PLACEHOLDER_STORM_NIMBUS%/$nimbushost/g" | \
perl -pe "s|%PLACEHOLDER_STORM_CLASSPATH%|$JDK8_INSTALL_DIR/lib:$STORM_INSTALL_DIR/lib|g" | \
perl -pe "s|%PLACEHOLDER_STORM_DIR%|$SERVIOTICY_INSTALL_DIR/storm_data|g" > $STORM_INSTALL_DIR/conf/storm.yaml

cd $ROOT