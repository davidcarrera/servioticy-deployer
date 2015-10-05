#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

rm -rf $ELASTICSEARCH_LOG_FILE

echo Starting ElasticSearch...
cd $ES_INSTALL_DIR
bin/elasticsearch -d
echo Done

cd $ROOT
