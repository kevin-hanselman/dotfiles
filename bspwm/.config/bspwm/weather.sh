#!/bin/bash

set -euo pipefail

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

apikey=$(cut -d' ' -f1 "$dir/weather.rc")
#zipcode=$(cut -d' ' -f2 "$dir/weather.rc")
zipcode=$(curl -s 'https://duckduckgo.com/?q=what+is+my+ip&ia=answer&format=json' | \
          jq .Answer | grep -Po '\b\d{5}\b' | tail -n1)

# worldweatheronline is limited to 250 API calls per day, or about one every 6 minutes; don't push it!
weather=$(curl -s "https://api.worldweatheronline.com/free/v2/weather.ashx?key=$apikey&q=$zipcode&format=json&num_of_days=1" | \
          jq -r '.data.current_condition[] | .temp_F, .weatherDesc[].value' | tr '\n' ' ')

temp=$(echo "$weather" | cut -d' ' -f1)°F
conditions=$(echo "$weather" | cut -d' ' -f2-)
conditions=$(echo "$conditions" | xargs)

echo "$temp $conditions"

# jq '.data.current_condition[]' =
# {
#     "cloudcover": "75",
#     "FeelsLikeC": "25",
#     "FeelsLikeF": "77",
#     "humidity": "61",
#     "observation_time": "07:16 PM",
#     "precipMM": "1.3",
#     "pressure": "1010",
#     "temp_C": "23",
#     "temp_F": "73",
#     "visibility": "16",
#     "weatherCode": "116",
#     "weatherDesc": [
#         {
#             "value": "Partly Cloudy"
#         }
#     ],
#     "weatherIconUrl": [
#         {
#             "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png"
#         }
#     ],
#     "winddir16Point": "SE",
#     "winddirDegree": "130",
#     "windspeedKmph": "13",
#     "windspeedMiles": "8"
# }
