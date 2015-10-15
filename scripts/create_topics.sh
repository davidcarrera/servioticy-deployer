#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $KAFKA_INSTALL_DIR
zk_machine=$(head -n 1 $MACHINE_FILES_FOLDER/$MACHINE_FILE_ZK)

echo "Creating kafka topics"

#./bin/kafka-topics.sh --zookeeper $zk_machine:2181 --create --topic reputation --partitions 8 --replication-factor 1 --config retention.ms=120000
./bin/kafka-topics.sh --zookeeper $zk_machine:2181 --create --topic updates --partitions 8 --replication-factor 1 --config retention.ms=120000
#./bin/kafka-topics.sh --zookeeper $zk_machine:2181 --create --topic actions --partitions 8 --replication-factor 1 --config retention.ms=120000

cd $ROOT