#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


echo Starting Dispatcher...

cd $DISPATCHER_INSTALL_DIR

python ./storm kill dispatcher

until python $STORM_INSTALL_DIR/bin/storm jar ./$DISPATCHER_JAR com.servioticy.dispatcher.DispatcherTopology -t dispatcher -f ./dispatcher.xml
do
  echo "Trying again"
done

python $STORM_INSTALL_DIR/bin/storm rebalance dispatcher -n 4 -e updates=48 -e prepare=48 -e streamdispatcher=48 -e streamprocessor=48 -e subretriever=48

cd $ROOT