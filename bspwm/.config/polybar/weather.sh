#!/bin/bash

set -euo pipefail

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

apikey=$(cut -d' ' -f1 "$dir/weather.rc")
zipcode=$(curl -s 'https://duckduckgo.com/?q=what+is+my+ip&ia=answer&format=json' | \
          jq .Answer | grep -Po '\b\d{5}\b' | tail -n1)

response=$(curl --compressed -s "https://api.apixu.com/v1/current.json?key=${apikey}&q=${zipcode}" | \
           jq .current)

temp="$(echo "$response" | jq -r '.feelslike_f')°F"
conditions=$(echo "$response" | jq -r '.condition.text')

echo "$temp $conditions"

# Example:
#{
#    "location": {
#        "name": "Portland",
#        "region": "Maine",
#        "country": "USA",
#        "lat": 43.66,
#        "lon": -70.29,
#        "tz_id": "America/New_York",
#        "localtime_epoch": 1496437927,
#        "localtime": "2017-06-02 17:12"
#    },
#    "current": {
#        "last_updated_epoch": 1496437209,
#        "last_updated": "2017-06-02 17:00",
#        "temp_c": 20.0,
#        "temp_f": 68.0,
#        "is_day": 1,
#        "condition": {
#            "text": "Partly cloudy",
#            "icon": "//cdn.apixu.com/weather/64x64/day/116.png",
#            "code": 1003
#        },
#        "wind_mph": 10.5,
#        "wind_kph": 16.9,
#        "wind_degree": 270,
#        "wind_dir": "W",
#        "pressure_mb": 1010.0,
#        "pressure_in": 30.3,
#        "precip_mm": 0.4,
#        "precip_in": 0.02,
#        "humidity": 35,
#        "cloud": 75,
#        "feelslike_c": 20.0,
#        "feelslike_f": 68.0,
#        "vis_km": 16.0,
#        "vis_miles": 9.0
#    }
#}
