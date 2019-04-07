#!/bin/bash
# Search text in selected folder
cd "$1"
# Get text to search
SearchText=$(zenity --entry --title="Search Directory" --text="For Text:" --width=250)
if [ -z "$SearchText" ]; then
	notify-send "Search Directory" "Nothing entered; exiting..." &
	exit
else
	if [ -f "/tmp/Search-Directory-Results.txt" ]
	then
		rm "/tmp/Search-Directory-Results.txt"
	fi
	grep_menu()
	{
	im="zenity --list --radiolist --title=\"Search Directory\" --text=\"Please select one of the search options below:\""
	im=$im" --column=\"☉\" --column \"Option\" --column \"Description\" "
	im=$im"TRUE \"case-sensitive\" \"Match only: Text\" "
	im=$im"FALSE \"case-insensitive\" \"Match: TEXT, text, Text...\" "
	}
	grep_option()
	{
	choice=$(echo "$im" | sh -)
	if echo "$choice" | grep -iE "case-sensitive|case-insensitive" > /dev/null
	then
		if echo "$choice" | grep "case-sensitive" > /dev/null
		then
			grep -- "$SearchText" *.* > "/tmp/Search-Directory-Results.txt"
		fi
		if echo "$choice" | grep "case-insensitive" > /dev/null
		then
			grep -i -- "$SearchText" *.* > "/tmp/Search-Directory-Results.txt"
		fi
	fi
	}
	grep_menu
	grep_option
fi
if [ ! -s "/tmp/Search-Directory-Results.txt" ]
then
	notify-send "Search Directory" "\"$SearchText\" not found in the selected directory!" &
else
	zenity	--class=LIST --text-info \
			--editable \
			--title="\"$SearchText\" found in directory:" \
			--filename="/tmp/Search-Directory-Results.txt"
fi
exit 0
# grep -io -- "$SearchText" *.* > "/tmp/Search-Directory-Results.txt"
# --width 600 --height 600 \
# -o, --only-matching       show only the part of a line matching PATTERN
# -i, --ignore-case         ignore case distinctions
