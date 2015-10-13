#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $MYSQL_INSTALL_DIR
./bin/mysqladmin -h 127.0.0.1 -P 3307 -u root shutdown
cd $ROOT