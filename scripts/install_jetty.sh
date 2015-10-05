#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$JETTY_FILE
folder=`ls -1 | grep jetty- | head -1`
ln -s $folder $JETTY_INSTALL_DIR

nodes=`cat $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY | perl -pe "s/\n/\",/g" | perl -pe "s/^/\"/g" | perl -pe "s/,$//g" | perl -pe "s/,/,\"/g"`
nodename=`hostname -f`

crossorigin=`grep module-servlets $JETTY_INSTALL_DIR/start.ini | wc -l`

if [ $crossorigin -le 0 ]
then
	echo "--module=servlets" >> $JETTY_INSTALL_DIR/start.ini
fi

cd $ROOT
