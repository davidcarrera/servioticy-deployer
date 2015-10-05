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
cd $ROOT
