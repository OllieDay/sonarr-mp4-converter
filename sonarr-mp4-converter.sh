#!/bin/bash

if ! command -v ffmpeg > /dev/null; then
	>&2 echo "FFmpeg is not installed."
	exit 1
fi

if [ ! $sonarr_eventtype ]; then
	>&2 echo "sonarr_eventtype is not set."
	exit 1
fi

# Skip all events except Download
if [ $sonarr_eventtype != "Download" ]; then
	exit 0
fi

if [ ! "$sonarr_isupgrade" ]; then
	>&2 echo "sonarr_isupgrade is not set."
	exit 1
fi

if [ ! "$sonarr_episodefile_path" ]; then
	>&2 echo "sonarr_episodefile_path is not set."
	exit 1
fi

if [ ! -f "$sonarr_episodefile_path" ]; then
	>&2 echo "File $sonarr_episodefile_path not found."
	exit 1
fi

destination="${sonarr_episodefile_path%.*}.mp4"

# Only overwrite the destination file if sonarr_isupgrade is set to True
if [ $sonarr_isupgrade != "True" ] && [ -f "$destination" ]; then
	>&2 echo "File $destination already exists."
	exit 1
fi

if ! ffmpeg -i "$sonarr_episodefile_path" -codec copy -y "$destination" &> /dev/null; then
	>&2 echo "Failed to convert $sonarr_episodefile_path"
	exit 1
fi

# Remove original file as it's no longer needed
rm "$sonarr_episodefile_path"
