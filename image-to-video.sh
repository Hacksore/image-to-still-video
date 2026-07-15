#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input-image> <output.mp4>" >&2
  exit 1
fi

input_image="$1"
output_video="$2"

if [[ ! -f "$input_image" ]]; then
  echo "Input image not found: $input_image" >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required but was not found in PATH." >&2
  exit 1
fi

if ! ffmpeg -y \
  -loop 1 \
  -i "$input_image" \
  -c:v libx264 \
  -t 5 \
  -r 30 \
  -pix_fmt yuv420p \
  -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
  -movflags +faststart \
  "$output_video"; then
  echo "Failed to create video with ffmpeg." >&2
  exit 1
fi

echo "Video created successfully: $output_video"
