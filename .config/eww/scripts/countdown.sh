#!/bin/bash
TARGET="2025-10-24 23:59:59" # Target date and time (24-Format) here

# Get timestamps
current_timestamp=$(date +%s)
target_timestamp=$(date -d "$TARGET" +%s 2>/dev/null)

# Check if target date is valid
if [[ -z "$target_timestamp" ]]; then
  echo "Invalid target date format"
  exit 1
fi

# Calculate total difference in seconds
total_diff=$((target_timestamp - current_timestamp))
abs_diff=$((total_diff < 0 ? -total_diff : total_diff))

# Break down the time difference
seconds=$((abs_diff % 60))
minutes=$(((abs_diff / 60) % 60))
hours=$(((abs_diff / 3600) % 24))
days=$((abs_diff / 86400))

# Apply negative sign to the largest non-zero component if past target
if [[ $total_diff -lt 0 ]]; then
  if [[ $days -gt 0 ]]; then
    days=$((-days))
  elif [[ $hours -gt 0 ]]; then
    hours=$((-hours))
  elif [[ $minutes -gt 0 ]]; then
    minutes=$((-minutes))
  else
    seconds=$((-seconds))
  fi
fi

# Output with zero-padding
printf "%02d\n" $days
printf "%02d\n" $hours
printf "%02d\n" $minutes
printf "%02d\n" $seconds
