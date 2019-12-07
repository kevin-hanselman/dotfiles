#!/bin/bash

set -euo pipefail

weather_executable=~/go/bin/weather

[ -x "$weather_executable" ] || go get github.com/genuinetools/weather

degrees='°F'

weather_json=$("$weather_executable" --json)
current_temp=$(echo "$weather_json" | jq -r '.currently.apparentTemperature' | xargs printf '%.*f' 1)
low_temp=$(echo "$weather_json" | jq -r '.daily.data[0].apparentTemperatureMin' | xargs printf '%.*f' 1)
high_temp=$(echo "$weather_json" | jq -r '.daily.data[0].apparentTemperatureMax' | xargs printf '%.*f' 1)
summary=$(echo "$weather_json" | jq -r '.daily.data[0].summary')

echo "$low_temp / $current_temp / $high_temp $degrees, ${summary,,}"
