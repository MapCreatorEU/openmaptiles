#!/usr/bin/env sh

./setup_base.sh
while read country
do
    ./run_country.sh $country
    echo $country >> completed.txt
    aws s3 cp data/tiles.mbtiles s3://m4n-highlight/$country.mbtiles
    ./notify-send --chanell="notify-sven" --message="$country uploaded :heavy_check_mark"
done < countries.txt
