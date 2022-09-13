import:
	./import.sh
	./import_s3.sh
	docker exec -i pws_postgres /usr/bin/psql -U postgres -f sql/insert_s3.sql

export-csv:
	docker exec -i pws_postgres /usr/bin/psql -U postgres -c '\copy pws to STDIN CSV HEADER;' \
	| gzip > data-raw/export.csv.gz

drop-tables:
	docker exec -i pws_postgres /usr/bin/psql -U postgres -f sql/drop_tables.sql

move-s3-imported:
	rsync --remove-source-files --recursive --checksum --verbose data-raw/playfab-s3/ data-raw/imported/playfab-s3/
	