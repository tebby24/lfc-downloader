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


# Select series
echo "Available series:"
series_list=$(jq -r 'keys[]' "$URLS_FILE")
select_series=()
index=1
for series in $series_list; do
    echo "$index) $series"
    select_series+=("$series")
    ((index++))
done

read -p "Select a series by number: " series_choice
series=${select_series[$((series_choice - 1))]}

# Select episodes
episode_count=$(jq ".\"$series\" | length" "$URLS_FILE")
echo "There are $episode_count episodes available for '$series'."
read -p "Enter episode numbers to download (e.g., '1', '1,3,5', '1-3', or leave blank for all): " episode_choice

# Process episode selection
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

# Output directory
read -p "Enter output directory (default: ~/Downloads): " output_dir
output_dir="${output_dir:-$HOME/Downloads}"
mkdir -p "$output_dir/$series"

# Download selected episodes
for episode_index in $episodes; do
    download_episode "$series" "$episode_index" "$output_dir"
done

echo "Download complete!"
