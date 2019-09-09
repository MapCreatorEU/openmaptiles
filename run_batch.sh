#!/usr/bin/env sh

readonly CHANNEL="notify-sven"
readonly COUNTRY_FILE="country_set.yaml"

ip=$(curl ipinfo.io/ip)

echo "" > completed.txt

readonly count=$(cat $COUNTRY_FILE  | yq .[].code | wc -l)
for i in `seq 0 $count`; do
    country=$(cat $COUNTRY_FILE | yq .[$i].name)
    iso_code=$(cat $COUNTRY_FILE | yq .[$i].code)
    iso_code=$(echo $iso_code | tr -d \")
    country=$(echo $country | tr -d \")

    sed -i '/^ISO_CODE/d' .env
    echo "ISO_CODE=$iso_code" >> .env

    ./run_country.sh $country >> log 2>&1
    aws s3 cp data/tiles.mbtiles s3://m4n-highlight/$country.mbtiles >> log 2>&1
    ./notify-slack --channel="$CHANNEL" --message="$country uploaded :heavy_check_mark:"
    echo "$country" >> completed.txt
done

./notify-slack --channel="$CHANNEL" --message="Done with calculating $ip"
