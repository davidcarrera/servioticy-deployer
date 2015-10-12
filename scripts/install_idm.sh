#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing IDM"
mkdir -p $SERVIOTICY_INSTALL_DIR
mkdir -p $IDM_INSTALL_DIR

cd $FILE_REPOSITORY/IDM

cat $IDM_APPLICATION_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_IDM_PORT%/8082/g" > ./src/main/resources/application.properties

pipurl=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY)

cat $IDM_PIP_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_IDM_PIP_URL%/$pipurl/g" > ./src/main/resources/pip.properties

./compile_jar.sh

cp ./build/libs/COMPOSEIdentityManagement-0.8.0.jar $IDM_INSTALL_DIR/

cd $ROOT
