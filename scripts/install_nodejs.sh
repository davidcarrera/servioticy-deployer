#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing node.js"
mkdir -p $SERVIOTICY_INSTALL_DIR
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$NODEJS_FILE
folder=`ls -1 | grep nodejs | head -1`
ln -s $folder $NODEJS_INSTALL_DIR
cd $ROOT
