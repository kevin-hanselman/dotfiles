function mon-geo
    bspc wm -d | \
        jq -r -c '.focusedMonitorId as $monid |
                  .monitors[] |
                  select(.id == $monid) .rectangle |
                  [.width, .height] |
                  "\(.[0])x\(.[1])"'
end
