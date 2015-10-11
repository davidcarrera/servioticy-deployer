#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $SECURITY_INSTALL_DIR

nohup node SecurityServer.js `</dev/null` > $SERVIOTICY_INSTALL_DIR/securityserver.out 2>&1 &
exit

cd $ROOT

exit 0