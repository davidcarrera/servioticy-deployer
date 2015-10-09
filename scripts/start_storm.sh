#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $STORM_INSTALL_DIR

if [ -f $SERVIOTICY_INSTALL_DIR/storm_nimbus ]; then
    nohup ./bin/storm nimbus
    nohup ./bin/storm ui
fi

if [ -f $SERVIOTICY_INSTALL_DIR/storm_supervisor ]; then
    nohup ./bin/storm supervisor
fi

cd $ROOT

exit 0
