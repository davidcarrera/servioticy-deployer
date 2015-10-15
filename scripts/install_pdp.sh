#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing PDP"
mkdir -p $SERVIOTICY_INSTALL_DIR

cp -R $FILE_REPOSITORY/pdp $PDP_INSTALL_DIR/
cd $PDP_INSTALL_DIR/resources/main/lib/
mvn install:install-file -Dfile=IoTP-0.1.0.jar -DpomFile=pom.xml

cd $PDP_INSTALL_DIR/
gradle install

cd $ROOT


