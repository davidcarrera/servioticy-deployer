#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $KAFKA_INSTALL_DIR

./bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_ADDR --replication-factor 1 --partitions 1 --config retention.ms=120000 --topic updates &> /dev/null
./bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_ADDR --replication-factor 1 --partitions 1 --config retention.ms=120000 --topic actions &> /dev/null
./bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_ADDR --replication-factor 1 --partitions 1 --config retention.ms=120000 --topic reputation &> /dev/null

cd $ROOT
exit 0