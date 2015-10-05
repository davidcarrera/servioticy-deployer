if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


#dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "kill -9 -1"
dsh -f $MACHINE_FILES_FOLDER/$MACHINE_FILE_CB  "rm -rf $SERVIOTICY_INSTALL_DIR"


