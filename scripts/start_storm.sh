#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $STORM_INSTALL_DIR

if [ -f $SERVIOTICY_INSTALL_DIR/storm_nimbus ]; then
    nohup ./bin/storm nimbus `</dev/null` > $SERVIOTICY_INSTALL_DIR/stormnimbus.out 2>&1 &
    nohup ./bin/storm ui `</dev/null` > $SERVIOTICY_INSTALL_DIR/stormgui.out 2>&1 &
    exit
fi

if [ -f $SERVIOTICY_INSTALL_DIR/storm_supervisor ]; then
    nohup ./bin/storm supervisor `</dev/null` > $SERVIOTICY_INSTALL_DIR/stormsupervisor.out 2>&1 &
    exit
fi

cd $ROOT

exit 0
