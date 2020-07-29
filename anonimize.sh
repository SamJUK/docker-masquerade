#!/bin/bash

FILE="$1"

if [ -z "$1" ]
  then
    echo "No dump file supplied"
    exit 1;
fi

# Create a MySQL Server
echo "Creating Database Container"
DB_CONTAINER=$(docker run -d -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=masquerade -e MYSQL_USER=masquerade -e MYSQL_PASSWORD=masquerade percona/percona-server:5.6)
echo "> DB Container: $DB_CONTAINER"

DB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $DB_CONTAINER)
echo "> DB Container IP: $DB_IP"

# Waiting for DB to be up and ready
# @TODO: Imlpement properly
sleep 30;

# Import Our SQL
echo "Importing SQL File"
echo "> $FILE"
docker exec -i $DB_CONTAINER mysql -uroot -proot masquerade < $FILE

# Anonymize our imported data
echo "Running Masquerade"
docker run samjuk/masquerade run --platform=magento2 --host=${DB_IP} --database=masquerade --prefix=je32_  --username=masquerade --password=masquerade --locale=en_GB
  
# Dump the anon data
echo "Creating Dump"
# DUMPFILE="$FILE.anon.$(date '+%s').sql"
DUMPFILE="$FILE.anon.sql"
rm $DUMPFILE
echo "> Dumpname: $DUMPFILE"
docker exec -i $DB_CONTAINER mysqldump -uroot -proot masquerade > $DUMPFILE

# Cleanup
echo "Cleaning Up..."
docker stop $DB_CONTAINER
docker rm $DB_CONTAINER
# ls -t *anon*.sql | tail -n +4 | xargs rm --
