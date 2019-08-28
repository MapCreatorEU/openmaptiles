#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

make refresh-docker-images
make clean-docker
mkdir -p pgdata
mkdir -p build
mkdir -p data
mkdir -p wikidata
rm -f ./data/*.mbtiles
make clean
make
docker-compose up -d postgres
make forced-clean-sql
docker-compose run --rm import-water
docker-compose run --rm import-natural-earth
