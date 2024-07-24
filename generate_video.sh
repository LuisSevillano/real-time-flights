mkdir -p video

ffmpeg -y \
    -pattern_type glob -i 'images/*.jpg' \
    -vf "fps=15,format=yuv420p" \
    video/flights.mp4

ffmpeg -y \
    -i video/flights.mp4 \
    -vf "fps=30,scale=1200:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 video/flights.gif
