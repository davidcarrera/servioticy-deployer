#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $UAA_INSTALL_DIR/

mvn tomcat7:run -Dmaven.tomcat.port=8081

cd $ROOT


