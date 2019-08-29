#!/usr/bin/env sh

CHANNEL="notify-sven"

ip=$(curl ipinfo.io/ip)

./notify-slack --channel="$CHANNEL" --message="Started with pre-processing $ip"
./setup_base.sh
./notify-slack --channel="$CHANNEL" --message="done with pre-processing $ip"
while read country
do
    ./run_country.sh $country
    echo $country >> completed.txt
    aws s3 cp data/tiles.mbtiles s3://m4n-highlight/$country.mbtiles
    ./notify-slack --channel="$CHANNEL" --message="$country uploaded :heavy_check_mark:"
done < countries.txt

./notify-slack --channel="$CHANNEL" --message="Done with calculating $ip"
