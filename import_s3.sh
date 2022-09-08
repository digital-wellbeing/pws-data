#!/bin/bash
for file in $(find data-raw/playfab-s3 -name '*.json.gz'); do 
    echo "$file"
    gunzip -c $file | jq -c '.EventData' | docker exec -i pws_postgres /usr/bin/psql -U postgres -c 'COPY tmp (data) FROM STDIN'
    docker exec -i pws_postgres /usr/bin/psql -U postgres --set=pwstable='pws_s3' -f sql/import.sql
done