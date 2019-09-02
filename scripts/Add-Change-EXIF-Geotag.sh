#!/bin/sh
OLDIFS=$IFS
IFS="
"
GPSLatitude="$(zenity --entry --title="Add/Change Exif GPS Latitude value" --text="Enter GPS Latitude DMS values as shown:" --entry-text="41 02 44.52")"
GPSLatitudeRef="$(zenity --entry --title="Add/Change Exif GPS Latitude Reference i.e. North/South value" --text="Enter GPS Latitude Reference values as N or S:" --entry-text="N")"
GPSLongitude="$(zenity --entry --title="Add/Change Exif GPS Longitude value" --text="Enter GPS Longitude DMS values as shown:" --entry-text="29 02 04.37")"
GPSLongitudeRef="$(zenity --entry --title="Add/Change Exif GPS Longitude Reference i.e. East/West value" --text="Enter GPS Longitude Reference values as E or W:" --entry-text="E")"

for filename in $@
do
	exiftool -GPSLatitude="$GPSLatitude" "$filename" -overwrite_original
	exiftool -GPSLatitudeRef="$GPSLatitudeRef" "$filename" -overwrite_original
	exiftool -GPSLongitude="$GPSLongitude" "$filename" -overwrite_original
	exiftool -GPSLongitudeRef="$GPSLongitudeRef" "$filename" -overwrite_original
done
IFS=$OLDIFS
