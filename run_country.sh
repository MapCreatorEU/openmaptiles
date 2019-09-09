#!/usr/bin/env sh
rm -rf ./data/*
make download-geofabrik area=$1
#docker-compose run --rm import-osm
docker-compose run --rm import-sql
make psql-analyze
docker-compose run --rm import-countries
docker-compose -f docker-compose.yml -f ./data/docker-compose-config.yml run --rm generate-vectortiles
docker-compose run --rm openmaptiles-tools  generate-metadata ./data/tiles.mbtiles
docker-compose run --rm openmaptiles-tools  chmod 666         ./data/tiles.mbtiles
