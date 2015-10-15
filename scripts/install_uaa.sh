#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing UAA"
mkdir -p $SERVIOTICY_INSTALL_DIR

cp -R $FILE_REPOSITORY/uaa $UAA_INSTALL_DIR/
cd $UAA_INSTALL_DIR/

mvn install

cd $ROOT


