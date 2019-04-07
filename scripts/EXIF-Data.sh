#!/bin/bash
# Use exiftool to view metadata of the selected audio, video or image file(s).
# Requires zenity and exiftool
#
OLDIFS=$IFS
IFS="
"
for filename in "$@"
do
# Create a temporary file in the /tmp folder to store the output
TITLE=$(basename "$filename")
LOGFILE=$(mktemp -t exif-info.XXXXXX)
#
exiftool "$filename" 2>&1 > "$LOGFILE"
#
# Check if the temp file is empty: if true the input file is not a supported file format
if [ ! -s "$LOGFILE" ]
then
	zenity --error --text="File format not supported!"
else
	zenity --text-info --title="$TITLE EXIF Data (Read Only)" --filename="$LOGFILE" --width=550 --height=450
#
# remove temp file when the zenity window is closed
rm -f "$LOGFILE"
fi
done
IFS=$OLDIFS
