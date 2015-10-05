#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $ES_INSTALL_DIR
bin/plugin -install transport-couchbase -url \
http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/2.1.1/elasticsearch-transport-couchbase-2.1.1.zip

bin/plugin -install mobz/elasticsearch-head 
cd $ROOT
