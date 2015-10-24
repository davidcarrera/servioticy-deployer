#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Maven"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
unzip $FILE_REPOSITORY/$MAVEN_FILE
folder=`ls -1 | grep maven | head -1`
ln -s $folder $MAVEN_INSTALL_DIR
cd $ROOT
