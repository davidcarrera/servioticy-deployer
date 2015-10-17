#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


echo Starting Dispatcher...

cd $STORM_INSTALL_DIR/bin
python ./storm kill dispatcher

until python storm jar $DISPATCHER_INSTALL_DIR/dispatcher-0.4.3-security-SNAPSHOT-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -t dispatcher -f $DISPATCHER_INSTALL_DIR/dispatcher.xml
do
  echo "Trying again"
done

python ./storm rebalance dispatcher-secure -n 4 -e updates=48 -e prepare=48 -e streamdispatcher=48 -e streamprocessor=48 -e subretriever=48

cd $ROOT