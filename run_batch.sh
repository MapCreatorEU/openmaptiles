#!/usr/bin/env sh

./notify-send --channel="notify-sven" --message="Started with pre-processing"
./setup_base.sh
./notify-send --channel="notify-sven" --message="done with pre-processing"
while read country
do
    ./run_country.sh $country
    echo $country >> completed.txt
    aws s3 cp data/tiles.mbtiles s3://m4n-highlight/$country.mbtiles
    ./notify-send --channel="notify-sven" --message="$country uploaded :heavy_check_mark"
done < countries.txt
