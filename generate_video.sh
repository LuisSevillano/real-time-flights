#!/bin/bash

# Create the output directory if it does not exist
mkdir -p video

# Get current date and time in milliseconds
current_time=$(($(date +%s) * 1000))
echo $current_time

# Filter images from the last 24 hours (86400000 milliseconds)
last_24h_images=()
for image in images/world_map_*.jpg; do

    # Extract timestamp from filename
    timestamp_file=$(basename "$image" | tr -dc '0-9')

    # Calculate the time difference
    diff_in_millisenconds=$((current_time - timestamp_file))
    day_as_milliseconds=86400000
    diff_in_days=$(echo "scale=2; $diff_in_millisenconds / $day_as_milliseconds" | bc)
    one_day=1.0
    # echo "${diff_in_days} ${timestamp_file} ${current_time}"
    if (( $(echo "$diff_in_days < $one_day" | bc -l) )); then
        last_24h_images+=("$image")
        echo "file '$image'" >> recent_images.txt
    fi
done

# Check for recent images
if [ ${#last_24h_images[@]} -gt 0 ]; then

    # Create video file from recent images
    ffmpeg -y \
        -f concat -safe 0 -i recent_images.txt \
        -vf "fps=60,format=yuv420p" \
        video/flights.mp4

    # Create gif file from video
    ffmpeg -y \
        -i video/flights.mp4 \
        -vf "fps=60,scale=830:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        -loop 0 video/flights.gif
else
    echo "No recent images were found within the last 24 hours.."
fi

# clean temp file
rm recent_images.txt
