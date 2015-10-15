#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing PDP"
mkdir -p $SERVIOTICY_INSTALL_DIR

cd $FILE_REPOSITORY/pdp/resources/main/lib/
mvn install:install-file -Dfile=IoTP-0.1.0.jar -DpomFile=pom.xml

cd $FILE_REPOSITORY/pdp/
gradle install

cd $ROOT


