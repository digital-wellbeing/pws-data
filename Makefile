define export_table_to_csv
	docker exec -i pws_postgres /usr/bin/psql -U postgres -c '\copy $(1) to STDIN CSV HEADER;' \
	| gzip > data-raw/export-$(1).csv.gz

endef

import:
	./import.sh
	./import_s3.sh
	docker exec -i pws_postgres /usr/bin/psql -U postgres -f sql/insert_s3.sql

export-csv:
	$(call export_table_to_csv,pws)

export-csv-device-info:
	$(call export_table_to_csv,pws_device_info)

drop-tables:
	docker exec -i pws_postgres /usr/bin/psql -U postgres -f sql/drop_tables.sql

move-s3-imported:
	mkdir -p data-raw/imported/playfab-s3/
	rsync --remove-source-files --recursive --checksum --verbose data-raw/playfab-s3/ data-raw/imported/playfab-s3/
	