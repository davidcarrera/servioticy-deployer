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

cd $FILE_REPOSITORY/idm

cp $IDM_APPLICATION_TEMPLATE_FILE ./src/main/resources/application.properties

pipurl=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_SECURITY)
jettyurl=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_JETTY)

cat $IDM_PIP_TEMPLATE_FILE | \
perl -pe "s|%PLACEHOLDER_IDM_PIP_URL%|http://$pipurl|g" > ./src/main/resources/pip.properties

cat $IDM_SERVIOTICY_TEMPLATE_FILE | \
perl -pe "s|%PLACEHOLDER_IDM_SERVIOTICY_PRIVATE_URL%|http://$jettyurl:8080/private/security/|g" > ./src/main/resources/servioticy.properties

cp $IDM_DATASOURCE_TEMPLATE_FILE ./src/main/resources/datasource.properties
#cp $IDM_UAA_TEMPLATE_FILE ./src/main/resources/uaa.properties

./compile_jar.sh

cp ./build/libs/COMPOSEIdentityManagement-0.8.0.jar $IDM_INSTALL_DIR/

cd $ROOT

./scripts/start_mysql.sh
sleep 5
./scripts/create_idm_database.sh
./scripts/stop_mysql.sh


