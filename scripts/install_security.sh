#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing security server"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
unzip $FILE_REPOSITORY/$SECURITY_FILE -d $SERVIOTICY_INSTALL_DIR
#folder=`ls -1 | grep security-server | head -1`
#ln -s $folder $SECURITY_INSTALL_DIR

cd $SECURITY_INSTALL_DIR
npm install

cd $ROOT