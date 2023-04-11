# PowerWash Simulator dataset

- Download cleaned data at [ZENODO]
- Preprint: [LINK]

This repository contains the code used to clean the raw Qualtrics and PlayFab data.

The cleaned data are openly available under [CC0 license](https://creativecommons.org/publicdomain/zero/1.0/).

# Data description

The dataset includes a codebook and the cleaned data as a DuckDB database dump (.csv files with code to read them back into a database). Here's an example way to read those data back into a DuckDB database. Assume you have the raw .csv files in a directory "data", then:

```r
db <- dbConnect(
  duckdb(), 
  dbdir = "example-database.duckdb", 
  read_only = FALSE
)
dbSendQuery(
  db,
  "IMPORT DATABASE 'data';"
)
dbListTables(db)
```

Users can also load the .csv files directly.

# Cleaning the raw data [internal use]

## Parsing the raw playfab JSON files

These are assumed to be in `data-raw/playfab-export` and the user's local OneDrive directory indicated in`.env`. Those data are not publicly available; this is for internal use only.

### Prerequisites

The preprocessing was run on Ubuntu 20.04.5 LTS, and requires (the version used in shown in the parenthesis):

- jq (v1.6)
- Docker (20.10.17, build 100c701)
- Docker-compose (v.2.7.0)

### Ingest JSON and export CSV

Use `docker-compose` to start postgres and pgAdmin (optional)

```bash
docker-compose up -d
```

Import JSON files to Postgres

```bash
make import
```

After this, remove or rename `data-raw/playfab-export`, so that the next import won't re-import the retrospective data export data. Another file will be saved in `data-raw/` that indicates which files from OneDrive/S3 have already been imported, so that those won't be duplicated in future imports, so it is safe to call make import again.

You will then have the database accessible at `localhost:5432`.

### Known problems

One file will throw an error. This can be ignored, since it only includes test data from before the study launched.

```bash
data-raw/playfab-export/pws-playfab-export-2022-08-17_10-00-00.json.gz
ERROR:  invalid input syntax for type json
DETAIL:  Token "SegmentAndDefinitions" is invalid.
CONTEXT:  JSON data, line 1: ...":{"SegmentDefinition":"[[{"SegmentAndDefinitions"
```

## Qualtrics data

The data processing R script reads the user's OneDrive location for the raw qualtrics data. Make sure this is defined properly in `.env`. Also make sure there is only one file in the qualtrics directory. That should be exported from Qualtrics with Export -> Export as CSV, and make sure the "Export all fields" is selected. Can be just a .csv or compressed.
