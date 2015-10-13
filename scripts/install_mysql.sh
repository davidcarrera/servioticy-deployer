#!/bin/bash

if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

echo "Installing MySQL"
mkdir -p $SERVIOTICY_INSTALL_DIR
mkdir -p $MYSQL_DATA_DIR
cd $SERVIOTICY_INSTALL_DIR
tar xzf $FILE_REPOSITORY/$MYSQL_FILE
folder=`ls -1 | grep mysql | head -1`
ln -s $folder $MYSQL_INSTALL_DIR

cat $MYSQL_CONF_TEMPLATE_FILE | \
perl -pe "s/%PLACEHOLDER_MYSQL_USER%/$USERNAME/g" | \
perl -pe "s|%PLACEHOLDER_MYSQL_BASEDIR%|$MYSQL_INSTALL_DIR|g" | \
perl -pe "s|%PLACEHOLDER_MYSQL_DATADIR%|$MYSQL_DATA_DIR|g" | \
perl -pe "s|%PLACEHOLDER_MYSQL_SOCKET%|$SERVIOTICY_INSTALL_DIR/mysql.sock|g" > $MYSQL_INSTALL_DIR/my.cnf

cd $MYSQL_INSTALL_DIR/
./scripts/mysql_install_db --defaults-file=$MYSQL_INSTALL_DIR/my.cnf \
--basedir=$MYSQL_INSTALL_DIR \
--datadir=$MYSQL_DATA_DIR \
--socket=$SERVIOTICY_INSTALL_DIR/mysql.sock

cd $ROOT
