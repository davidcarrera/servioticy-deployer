#!/bin/bash
if [ -z "$ROOT" ]
then
    ROOT=$(while ! test -e env.sh.sample; do cd ..; done; pwd)
    export ROOT
fi

. $ROOT/env.sh


mkdir -p $FILE_REPOSITORY

echo Downloading MD5 and SHA1 files
rm -f $FILE_REPOSITORY/$CB_FILE_MD5
rm -f $FILE_REPOSITORY/$JETTY_FILE_MD5
rm -f $FILE_REPOSITORY/$ES_FILE_SHA1
rm -f $FILE_REPOSITORY/$ZK_FILE_MD5
rm -f $FILE_REPOSITORY/$KAFKA_FILE_MD5
rm -f $FILE_REPOSITORY/$STORM_FILE_MD5
rm -f $FILE_REPOSITORY/$SECURITY_FILE_MD5
rm -f $FILE_REPOSITORY/$MYSQL_FILE_MD5

wget -q $CB_FILE_WGET/$CB_FILE_MD5 -O $FILE_REPOSITORY/$CB_FILE_MD5.remove
wget -q $JETTY_FILE_WGET/$JETTY_FILE_MD5 -O $FILE_REPOSITORY/$JETTY_FILE_MD5.remove
wget -q $ES_FILE_WGET/$ES_FILE_SHA1 -O $FILE_REPOSITORY/$ES_FILE_SHA1
echo "$JDK8_MD5 $JDK8_FILE" > $FILE_REPOSITORY/$JDK8_FILE_MD5
wget -q $ZK_FILE_WGET/$ZK_FILE_MD5 -O $FILE_REPOSITORY/$ZK_FILE_MD5
echo "$KAFKA_MD5 $KAFKA_FILE" > $FILE_REPOSITORY/$KAFKA_FILE_MD5
echo "$STORM_MD5 $STORM_FILE" > $FILE_REPOSITORY/$STORM_FILE_MD5
echo "$NODEJS_MD5 $NODEJS_FILE" > $FILE_REPOSITORY/$NODEJS_FILE_MD5
echo "$SECURITY_MD5 $SECURITY_FILE" > $FILE_REPOSITORY/$SECURITY_FILE_MD5
echo "$MYSQL_MD5 $MYSQL_FILE" > $FILE_REPOSITORY/$MYSQL_FILE_MD5

perl -pe "s/$/ $CB_FILE/g" $FILE_REPOSITORY/$CB_FILE_MD5.remove | head -1> $FILE_REPOSITORY/$CB_FILE_MD5
perl -pe "s/$/ $JETTY_FILE/g" $FILE_REPOSITORY/$JETTY_FILE_MD5.remove | head -1> $FILE_REPOSITORY/$JETTY_FILE_MD5

rm $FILE_REPOSITORY/$CB_FILE_MD5.remove
rm $FILE_REPOSITORY/$JETTY_FILE_MD5.remove

cd $FILE_REPOSITORY

count=`md5sum -c $CB_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $CB_FILE_WGET/$CB_FILE
	wget -q $CB_FILE_WGET/$CB_FILE -O $FILE_REPOSITORY/$CB_FILE
else
	echo Verified file: $CB_FILE
fi

count=`sha1sum -c $ES_FILE_SHA1 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $ES_FILE_WGET/$ES_FILE
	wget -q $ES_FILE_WGET/$ES_FILE -O $FILE_REPOSITORY/$ES_FILE
else
	echo Verified file: $ES_FILE
fi


count=`md5sum -c $JDK8_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $JDK8_FILE_WGET/$JDK8_FILE
   wget -q -c -O "$FILE_REPOSITORY/$JDK8_FILE" \
	    --no-check-certificate --no-cookies \
		 --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JDK8_FILE_WGET}/${JDK8_FILE}"
else
	echo Verified file: $JDK8_FILE
fi

count=`md5sum -c $JETTY_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $JETTY_FILE_WGET/$JETTY_FILE
	wget -q $JETTY_FILE_WGET/$JETTY_FILE -O $FILE_REPOSITORY/$JETTY_FILE
else
	echo Verified file: $JETTY_FILE
fi

count=`md5sum -c $ZK_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $ZK_FILE_WGET/$ZK_FILE
	wget -q $ZK_FILE_WGET/$ZK_FILE -O $FILE_REPOSITORY/$ZK_FILE
else
	echo Verified file: $ZK_FILE
fi

count=`md5sum -c $KAFKA_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $KAFKA_FILE_WGET/$KAFKA_FILE
	wget -q $KAFKA_FILE_WGET/$KAFKA_FILE -O $FILE_REPOSITORY/$KAFKA_FILE
else
	echo Verified file: $KAFKA_FILE
fi

count=`md5sum -c $STORM_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $STORM_FILE_WGET/$STORM_FILE
	wget -q $STORM_FILE_WGET/$STORM_FILE -O $FILE_REPOSITORY/$STORM_FILE
else
	echo Verified file: $STORM_FILE
fi

count=`md5sum -c $NODEJS_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $NODEJS_FILE_WGET
	wget -q $NODEJS_FILE_WGET/$NODEJS_FILE -O $FILE_REPOSITORY/$NODEJS_FILE
else
	echo Verified file: $NODEJS_FILE
fi

count=`md5sum -c $SECURITY_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $SECURITY_FILE_WGET
	wget -q $SECURITY_FILE_WGET -O $FILE_REPOSITORY/$SECURITY_FILE
else
	echo Verified file: $SECURITY_FILE
fi

count=`md5sum -c $MYSQL_FILE_MD5 | grep -v OK | wc -l`
if [ $count -gt 0 ]
then
 	echo Corrupt or missing file found. Downloading $MYSQL_FILE_WGET/$MYSQL_FILE
	wget -q $MYSQL_FILE_WGET/$MYSQL_FILE -O $FILE_REPOSITORY/$MYSQL_FILE
else
	echo Verified file: $MYSQL_FILE
fi

git clone $IDM_GIT_URL ./idm
cd ./idm
git checkout $IDM_GIT_REVISION
git pull
echo IDM pulled

git clone $UAA_GIT_URL ./uaa
cd ./uaa
git checkout $UAA_GIT_REVISION
git pull
echo UAA pulled

git clone $PDP_GIT_URL ./pdp
cd ./pdp
git checkout $PDP_GIT_REVISION
git pull
echo PDP pulled

git clone $SERVIOTICY_GIT_URL ./servioticy
cd ./servioticy
git checkout $SERVIOTICY_GIT_REVISION
git pull
git submodule update --init --recursive
echo Servioticy pulled

cd $ROOT