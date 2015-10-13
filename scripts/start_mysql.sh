
if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh

cd $MYSQL_INSTALL_DIR
nohup ./bin/mysqld_safe --defaults-file=$MYSQL_INSTALL_DIR/my.cnf `</dev/null` > $SERVIOTICY_INSTALL_DIR/mysql.out 2>&1 &
exit
cd $ROOT

exit 0