#!/usr/bin/env bash
# to-gif.sh <in.webm> <out.gif> [start-sekunder]
# 960 px bred, 10 fps, palett per klipp. Ett 15 s UI-klipp blir 1-3 MB.
set -euo pipefail
in=$1; out=$2; start=${3:-0}
ffmpeg -v error -y -ss "$start" -i "$in" \
  -vf "fps=10,scale=960:-1:flags=lanczos,split[a][b];[a]palettegen=max_colors=128[p];[b][p]paletteuse=dither=bayer:bayer_scale=3" \
  "$out"
du -h "$out" >&2
