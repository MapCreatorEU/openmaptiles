#!/usr/bin/env sh

./setup_base.sh
while read country
do
    ./run_country.sh $country
done
