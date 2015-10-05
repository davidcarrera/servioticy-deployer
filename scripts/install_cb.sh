#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

mkdir -p $CB_INSTALL_DIR.dist

dpkg-deb -x $FILE_REPOSITORY/$CB_FILE $CB_INSTALL_DIR.dist
ln -s $CB_INSTALL_DIR.dist/opt/couchbase $CB_INSTALL_DIR
