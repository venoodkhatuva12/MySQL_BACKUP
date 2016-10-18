#!/bin/bash
#Script made for MYSQL BACKUP...
#Author: Vinod.N K
#Usage: Taking BAckup of MySQL DB.
#Distro : Linux -Centos, Rhel, and any fedora
#Check whether root user is running the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


echo "Login to MySql Server" 
MyUSER="root"     
MyPASS="password"      
MyHOST="localhost"       
 
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"
 

DEST="/backup"
 

MBD="$DEST/DB"
 
HOST="$(hostname)"
 

NOW="$(date +"%d-%m-%Y")"
 
echo "MySql Database backup is in process. This will take few minures."
FILE=""
DBS=""

IGGY="information_schema"
 
[ ! -d $MBD ] && mkdir -p $MBD || :
 

$CHOWN 0.0 -R $DEST
$CHMOD 0600 $DEST
 
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"
 
for db in $DBS
do
    skipdb=-1
    if [ "$IGGY" != "" ];
    then
  for i in $IGGY
  do
      [ "$db" == "$i" ] && skipdb=1 || :
  done
    fi
 
    if [ "$skipdb" == "-1" ] ; then
  FILE="$MBD/$db.$HOST.$NOW.gz"
        $MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
    fi
done

