#!/bin/bash
source .env
echo "OneDrive S3 Path:" $ONEDRIVE_PATH_S3
all=$(find "$ONEDRIVE_PATH_S3" -name '*.json.gz' | awk -F "/playfab-s3/" '{print $2}' | sort)
imported=$(cat data-raw/imported_s3.txt)
# Import only new files
files=$(diff <(echo "$imported") <(echo "$all") | awk -F "> " '/.json.gz/ {print $2}')
for file in $files; do 
    echo "Importing: $file"
    gunzip -c "${ONEDRIVE_PATH_S3}${file}" | jq -c '.EventData' | docker exec -i pws_postgres /usr/bin/psql -U postgres -c 'COPY tmp (data) FROM STDIN'
    docker exec -i pws_postgres /usr/bin/psql -U postgres --set=pwstable='pws_s3' --set=devicetable='pws_device_info_s3' -f sql/import.sql
done
echo "Do you whish to update 'imported_s3.txt'?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) mv data-raw/imported_s3.txt data-raw/imported_s3.txt.bak;
            echo "$all" > data-raw/imported_s3.txt; 
            break;;
        No ) exit;;
    esac
done
