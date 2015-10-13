#!/bin/bash

cd $MYSQL_INSTALL_DIR
./bin/mysqladmin -h 127.0.0.1 -P 3307 -u root shutdown