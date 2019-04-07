#!/bin/bash
#
OLDIFS=$IFS
IFS="
"
for filename in "$@"
do
	convert "$filename" "${filename%.*}.jpg"
done
IFS=$OLDIFS
