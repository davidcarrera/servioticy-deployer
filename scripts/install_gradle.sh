#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing Gradle"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
unzip $FILE_REPOSITORY/$GRADLE_FILE
folder=`ls -1 | grep gradle | head -1`
ln -s $folder $GRADLE_INSTALL_DIR
cd $ROOT
