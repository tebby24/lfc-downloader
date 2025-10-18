#!/bin/bash

# Define paths
DATA_DIR="./data"
URLS_FILE="$DATA_DIR/urls.json"
SUBTITLES_DIR="$DATA_DIR/subtitles"

# Function to download an episode
download_episode() {
    local series="$1"
    local episode_index="$2"
    local output_dir="$3"
    local episode_data="$(jq -r ".\"$series\"[$episode_index]" "$URLS_FILE")"

    # Extract details
    local title=$(echo "$episode_data" | jq -r ".title")
    local episode_id=$(echo "$episode_data" | jq -r ".id")
    local stream_url=$(echo "$episode_data" | jq -r ".stream_url")
    local xml_url=$(echo "$episode_data" | jq -r ".xml_url")

    # Define episode folder and filename
    local episode_dir="$output_dir/$series/$title"
    mkdir -p "$episode_dir"

    # Download the video using ffmpeg
    echo "Downloading episode '$episode_id'..."
    ffmpeg -i "$stream_url" -c copy "$episode_dir/$title.mp4"

    # Copy subtitle file if available
    subtitle_file="$SUBTITLES_DIR/$episode_id.srt"
    if [[ -f "$subtitle_file" ]]; then
        echo "Copying subtitle file for '$episode_id'..."
        cp "$subtitle_file" "$episode_dir/$title.srt"
    else
        echo "No subtitle file found for '$episode_id'."
    fi
}


# Select series (allow multiple selections)
echo "Available series:"
series_list=$(jq -r 'to_entries[] |.key' "$URLS_FILE")
select_series=()
index=1
for series in $series_list; do
    echo "$index) $series"
    select_series+=("$series")
    ((index++))
done

read -p "Enter series numbers to download (e.g., '1', '1,3,5', '1-3', or leave blank for all): " series_choice

# Process series selection into zero-indexed indices
selected_series_indices=()
if [[ -z "$series_choice" ]]; then
    # All series
    for i in "${!select_series[@]}"; do
        selected_series_indices+=("$i")
    done
else
    for part in $(echo "$series_choice" | sed 's/,/ /g'); do
        if [[ "$part" =~ ^[0-9]+$ ]]; then
            selected_series_indices+=("$((part - 1))")
        elif [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for i in $(seq $((${BASH_REMATCH[1]} - 1)) $((${BASH_REMATCH[2]} - 1))); do
                selected_series_indices+=("$i")
            done
        else
            echo "Invalid input: $part"
            exit 1
        fi
    done
fi

# Deduplicate and validate indices
declare -A _seen_series
selected_series=()
for idx in "${selected_series_indices[@]}"; do
    if [[ -z "${_seen_series[$idx]}" ]]; then
        if (( idx < ${#select_series[@]} )); then
            _seen_series[$idx]=1
            selected_series+=("${select_series[$idx]}")
        else
            echo "Series index $((idx + 1)) out of range"
            exit 1
        fi
    fi
done

# If only one series chosen, keep the existing episode-selection behavior; otherwise download all episodes for each selected series

# Output directory (ask once)
read -p "Enter output directory (default: ~/Downloads/lfc): " output_dir
# Default to ~/Downloads/lfc if the user presses enter
output_dir="${output_dir:-$HOME/Downloads/lfc}"

if [[ ${#selected_series[@]} -eq 1 ]]; then
    # Single series: prompt for episodes as before
    series="${selected_series[0]}"
    episode_count=$(jq ".\"$series\" | length" "$URLS_FILE")
    echo "There are $episode_count episodes available for '$series'."
    read -p "Enter episode numbers to download (e.g., '1', '1,3,5', '1-3', or leave blank for all): " episode_choice

    if [[ -z "$episode_choice" ]]; then
        episodes=$(seq 0 $((episode_count - 1)))  # All episodes (0-indexed)
    else
        # Convert to zero-indexed episode numbers
        episodes=""
        for part in $(echo "$episode_choice" | sed 's/,/ /g'); do
            if [[ "$part" =~ ^[0-9]+$ ]]; then
                episodes+="$((part - 1)) "
            elif [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                for i in $(seq $((${BASH_REMATCH[1]} - 1)) $((${BASH_REMATCH[2]} - 1))); do
                    episodes+="$i "
                done
            else
                echo "Invalid input: $part"
                exit 1
            fi
        done
    fi

    # Create the series directory under the chosen output root
    mkdir -p "$output_dir/$series"

    # Download selected episodes for the single series
    for episode_index in $episodes; do
        download_episode "$series" "$episode_index" "$output_dir"
    done
else
    # Multiple series: download all episodes for each selected series
    for series in "${selected_series[@]}"; do
        episode_count=$(jq ".\"$series\" | length" "$URLS_FILE")
        mkdir -p "$output_dir/$series"
        for episode_index in $(seq 0 $((episode_count - 1))); do
            download_episode "$series" "$episode_index" "$output_dir"
        done
    done
fi

echo "Download complete!"
