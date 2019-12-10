#!/bin/bash

set -euo pipefail

weather_executable=~/go/bin/weather

go get -u github.com/genuinetools/weather

degrees='°F'

weather_json=$("$weather_executable" --json)
current_temp=$(echo "$weather_json" | jq -r '.currently.apparentTemperature' | xargs printf '%.1f')
low_temp=$(echo "$weather_json" | jq -r '.daily.data[0].apparentTemperatureMin' | xargs printf '%.1f')
high_temp=$(echo "$weather_json" | jq -r '.daily.data[0].apparentTemperatureMax' | xargs printf '%.1f')
summary=$(echo "$weather_json" | jq -r '.daily.data[0].summary')

echo "$low_temp / $current_temp / $high_temp $degrees, ${summary,,}"
