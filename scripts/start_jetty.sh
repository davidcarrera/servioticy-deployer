#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $JETTY_INSTALL_DIR
bin/jetty.sh start  &> /dev/null
cd $ROOT

exit 0
