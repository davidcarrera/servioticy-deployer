#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $MYSQL_INSTALL_DIR

./bin/mysql --socket=$SERVIOTICY_INSTALL_DIR/mysql.sock -uroot -p -e "CREATE DATABASE IF NOT EXISTS composeidentity2;"
./bin/mysql --socket=$SERVIOTICY_INSTALL_DIR/mysql.sock -uroot -p -e "CREATE DATABASE IF NOT EXISTS uaadb;"

cd $ROOT