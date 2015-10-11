#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $IDM_INSTALL_DIR

nohup java -jar ./COMPOSEIdentityManagement-0.8.0.jar `</dev/null` > $SERVIOTICY_INSTALL_DIR/idm.out 2>&1 &
exit

cd $ROOT

exit 0