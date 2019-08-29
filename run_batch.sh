#!/usr/bin/env sh

CHANNEL="notify-sven"

ip=$(curl ipinfo.io/ip)

echo "" > completed.txt

./notify-slack --channel="$CHANNEL" --message="Started with pre-processing $ip"
./setup_base.sh
./notify-slack --channel="$CHANNEL" --message="done with pre-processing $ip"

for country in $(cat countries.txt)
do
    echo "$country" >> completed.txt
    ./run_country.sh $country
    aws s3 cp data/tiles.mbtiles s3://m4n-highlight/$country.mbtiles
    ./notify-slack --channel="$CHANNEL" --message="$country uploaded :heavy_check_mark:"
done

./notify-slack --channel="$CHANNEL" --message="Done with calculating $ip"
