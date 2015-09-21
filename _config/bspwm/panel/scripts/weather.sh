#!/bin/bash

set -eo pipefail
simple=
if [ "$1" == 'simple' ]; then
    simple='yes'
fi
set -u

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

apikey=$(cat "$dir/weather.rc" | cut -d' ' -f1)
zipcode=$(cat "$dir/weather.rc" | cut -d' ' -f2)

#echo "api key = $apikey"
#echo "zpicode = $zipcode"

# worldweatheronline is limited to 250 API calls per day, or about one every 6 minutes; don't push it!
weather=$(curl -s "https://api.worldweatheronline.com/free/v2/weather.ashx?key=$apikey&q=$zipcode&format=json&num_of_days=1" | \
              jq ".data.current_condition[].temp_F, .data.current_condition[].weatherDesc[].value" -r | tr '\n' ' ')


temp="$(echo "$weather" | cut -d' ' -f1)°F"
conditions="$(echo "$weather" | cut -d' ' -f2-)"
conditions="$(echo "$conditions" | sed -e 's/ *$//')"

icon=''
if [ -z "$simple" ]; then
    case "${conditions,,}" in
        partly*)
            icon=' '
            ;;
        cloudly)
            icon=' '
            ;;
        fog|haze)
            icon=' '
            ;;
        overcast)
            icon=' '
            ;;
        *snow*|*blizzard*|*sleet*|*ice*|*freezing*)
            icon=' '
            ;;
        *thunder*)
            icon=' '
            ;;
        *rain*)
            icon=' '
            ;;
        *drizzle*)
            icon=' '
            ;;
        *sunny*)
            icon=' '
            ;;
    esac
fi
echo "$temp$icon $conditions"

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
