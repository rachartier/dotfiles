#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

get_forecast() {
	local language=$(get_tmux_option @forecast-language "en")
	local location=$(get_tmux_option @forecast-location "")

    local color_sunny=$(get_tmux_option @forecast-color-sunny "#ffff00")
    local color_cloudy=$(get_tmux_option @forecast-color-cloudy "#aaaaaa")
    local color_snowy=$(get_tmux_option @forecast-color-snowy "#ffffff")
    local color_rainny=$(get_tmux_option @forecast-color-rainny "#00aaff")
    local color_stormy=$(get_tmux_option @forecast-color-stormy "#ffaa00")
    local color_default=$(get_tmux_option @forecast-color-default "#ff0000")

    local weather_string=$(curl -s -H "Accepted-Language: $language" "v2d.wttr.in/$location" | grep "Weather:" | cut -d "," -f 1,2 | tr ' ' '\n' | awk 'NR == 2 {print $1} END {print $1}' | awk '{ printf "%s  ", $0 }')
    local weather_unicode=$(echo $weather_string | awk '{print $1" "}')
    local temperature_string=$(echo $weather_string | awk '{print $2}')

    declare -A dict_weather_color=( [""]="#[fg=$color_default]" [" "]="#[fg=$color_cloudy]" [" "]="#[fg=$color_cloudy]" [" "]="#[fg=$color_rainny]" [" "]="#[fg=$color_rainny]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_rainny]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_default]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_snowy]" [" "]="#[fg=$color_sunny]" [" "]="#[fg=$color_sunny]" [" "]="#[fg=$color_stormy]" [" "]="#[fg=$color_stormy]" [" "]="#[fg=$color_stormy]" [" "]="#[fg=$color_cloudy]" )
    echo "${dict_weather_color[$weather_unicode]}$weather_unicode #[fg=$color_default] $temperature_string"
}

get_cached_forecast() {
	local cache_duration=$(get_tmux_option @forecast-cache-duration 0)                 # in seconds, by default cache is disabled
	local cache_path=$(get_tmux_option @forecast-cache-path "/tmp/tmux-weather.cache") # where to store the cached data
	local cache_age=$(get_file_age "$cache_path")
	local forecast
	if [ $cache_duration -gt 0 ]; then # Cache enabled branch
		# if file does not exist or cache age is greater then configured duration
		if ! [ -f "$cache_path" ] || [ $cache_age -ge $cache_duration ]; then
			forecast=$(get_forecast)
			# store forecast in $cache_path
			mkdir -p "$(dirname "$cache_path")"
			echo "$forecast" >"$cache_path"
		else
			# otherwise try to get it from cache file
			forecast=$(cat "$cache_path" 2>/dev/null)
		fi
	else # Cache disabled branch
		forecast=$(get_forecast)
	fi
	echo "$forecast"
}

print_forecast() {
	local char_limit=$(get_tmux_option @forecast-char-limit 75)
	local forecast=$(get_cached_forecast)
	echo ${forecast:0:$char_limit}
}

main() {
	print_forecast
}

main
