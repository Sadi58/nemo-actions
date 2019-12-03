#!/bin/bash
# Use exiftool to retrieve and dillo to view metadata of the selected audio, video or image file(s).
# Requires zenity, dillo and exiftool
# Viewer may also be zenity instead of dillo displaying exif data in html format
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
#	zenity --text-info --title="$TITLE EXIF Data (Read Only)" --filename="$LOGFILE" --width=550 --height=450
cat "$LOGFILE" | \
sed -e "s/^/<tr><td valign=top>/g" -e "s/$/<\/td><\/tr>/g" -e "s/\s\s*: /<\/td><td valign=top>/g" | \
sed '1i\
<html>\n<head>\n<title>EXIF Data</title>\n</head>\n<body>\n<table border=0>' | \
sed -e '$a</body></html>' > "$LOGFILE.html"
dillo -f "$LOGFILE.html"
# remove temp file(s)
rm -f "$LOGFILE"
rm -f "$LOGFILE.html"
fi
done
IFS=$OLDIFS
