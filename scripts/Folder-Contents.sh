#!/bin/sh
OLDIFS=$IFS
IFS="
"
DIR=$(echo "$1")
cd "$1"
# Provide options and then list contents of selected folder
menu_list()
{
im="zenity --list --radiolist --title=\"List Folder Contents\" --text=\"Select one of the options below to list the contents of selected folder:\" --width=540 --height=230"
im=$im" --column=\"☑\" --column \"Options\" --column \"Description\" "
im=$im"TRUE \"Root-File\" \"List filenames in the selected directory\" "
im=$im"FALSE \"Root-Path\" \"List pathnames in the selected directory\" "
im=$im"FALSE \"Recursive-File\" \"List filenames in the selected directory and its sub-directories\" "
im=$im"FALSE \"Recursive-Path\" \"List pathnames in the selected directory and its sub-directories\" "
}
option_list()
{
choice=$(echo "$im" | sh -)
if echo "$choice" | grep -iE "Root-File|Root-Path|Recursive-File|Recursive-Path" > /dev/null
then
	if echo "$choice" | grep "Root-File" > /dev/null
	then
		# List filenames in the selected directory
		find -maxdepth 1 -type f -printf '%p\n' > /tmp/FolderContents.txt
		sed -i "s/^.*\///g" /tmp/FolderContents.txt
		sort /tmp/FolderContents.txt -o /tmp/Folder-Contents.txt
		zenity	--class=LIST --text-info \
				--editable \
				--width 600 --height 400 \
				--title="Folder Contents" \
				--filename="/tmp/Folder-Contents.txt"
	fi
	if echo "$choice" | grep "Root-Path" > /dev/null
	then
		# List pathnames in the selected directory
		find -maxdepth 1 -type f -printf '%p\n' > "/tmp/FolderContents.txt"
		sort "/tmp/FolderContents.txt" -o "/tmp/Folder-Contents.txt"
		sed -i 's,^\.,'"$DIR"',' "/tmp/Folder-Contents.txt"
		zenity	--class=LIST --text-info \
				--editable \
				--width 600 --height 400 \
				--title="Folder Contents" \
				--filename="/tmp/Folder-Contents.txt"
	fi
	if echo "$choice" | grep "Recursive-File" > /dev/null
	then
		# List filenames in the selected directory and its sub-directories
		find -type f -printf '%p\n' > /tmp/FolderContents.txt
		sed -i "s/^.*\///g" /tmp/FolderContents.txt
		sort /tmp/FolderContents.txt -o /tmp/Folder-Contents.txt
		zenity	--class=LIST --text-info \
				--editable \
				--width 600 --height 400 \
				--title="Folder Contents" \
				--filename="/tmp/Folder-Contents.txt"
	fi
	if echo "$choice" | grep "Recursive-Path" > /dev/null
	then
		# List pathnames in the selected directory and its sub-directories
		find -type f -printf '%p\n' > /tmp/FolderContents.txt
		sort /tmp/FolderContents.txt -o /tmp/Folder-Contents.txt
		sed -i 's,^\.,'"$DIR"',' "/tmp/Folder-Contents.txt"
		zenity	--class=LIST --text-info \
				--editable \
				--width 600 --height 400 \
				--title="Folder Contents" \
				--filename="/tmp/Folder-Contents.txt"
	fi
fi
}
menu_list
option_list
IFS=$OLDIFS
