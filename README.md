# PowerWash Simulator dataset

This repository contains the cleaned data from the PowerWash Simulator study.

- `data-raw/` is not publicly available
  - Our scripts load the raw data from here and place it to `data/`
- `data/`
  - The processed datasets

## Parsing the raw JSON files

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
make import &> import.log
```

Export from Postgres to CSV (`data-raw/export.csv.gz`)

```bash
make export-csv
```

### Known problems

One file will throw an error. This can be ignored, since it only includes test data from before the study launched.

```bash
data-raw/playfab-export/pws-playfab-export-2022-08-17_10-00-00.json.gz
ERROR:  invalid input syntax for type json
DETAIL:  Token "SegmentAndDefinitions" is invalid.
CONTEXT:  JSON data, line 1: ...":{"SegmentDefinition":"[[{"SegmentAndDefinitions...
```
