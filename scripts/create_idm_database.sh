#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $MYSQL_INSTALL_DIR

./bin/mysql -uroot -e "CREATE DATABASE IF NOT EXISTS composeidentity2;"