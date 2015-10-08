#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing JDK"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$JDK8_FILE
folder=`ls -1 | grep jdk1.8 | head -1`
ln -s $folder $JDK8_INSTALL_DIR
cd $ROOT
