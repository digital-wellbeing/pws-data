#!/bin/bash
docker exec -i pws_postgres /usr/bin/psql -U postgres -f sql/create_tables.sql
for file in data-raw/playfab-export/*.json.gz; do 
    echo "$file"
    gunzip -c $file | jq -c '.Tables[0].Rows[][6]' | docker exec -i pws_postgres /usr/bin/psql -U postgres  -c 'COPY tmp (data) FROM STDIN'
    docker exec -i pws_postgres /usr/bin/psql -U postgres --set=pwstable='pws' -f sql/import.sql
done 