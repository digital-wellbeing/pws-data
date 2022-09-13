#!/bin/bash

files=$(rsync --dry-run --recursive --checksum --verbose data-raw/playfab-s3/ data-raw/imported/playfab-s3/ | awk '/.json.gz/ {print "data-raw/playfab-s3/"$1}')
for file in $files; do 
    echo "$file"
    gunzip -c $file | jq -c '.EventData' | docker exec -i pws_postgres /usr/bin/psql -U postgres -c 'COPY tmp (data) FROM STDIN'
    docker exec -i pws_postgres /usr/bin/psql -U postgres --set=pwstable='pws_s3' --set=devicetable='pws_device_info_s3' -f sql/import.sql
done