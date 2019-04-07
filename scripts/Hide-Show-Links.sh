#!/bin/bash 
#==============================================================================
#                               hide-show-links
#  Author  : SLK
#  Version : v2012051401 (modified and condensed herein)
#  License : Distributed under the terms of GNU GPL version 2 or later
#==============================================================================
#  Description:
#    nautilus-script to hide (show) symlinks creating/deleting/modifying .hidden file.
#
#  Information:
#    - a script for use (only) with Nautilus. 
#    - to use, copy to your ${HOME}/.local/share/nautilus/scripts/ directory.
#
#  WARNING:
#    - this script must be executable.
#    - packages "zenity" and "xdotool" must be installed.
#==============================================================================
#                                                                     CONSTANTS

# 0 or 1, if 1: doesn't create the hidden file
DRY_RUN=0

Labels used by zenity
z_title='Hide-Show Links'
z_error_message_cant_create_here='Can not write in this directory!'
z_error_message='Failed to create!'
z_success_hide_message='Links hidden now'
z_success_show_message='Links shown now'

#==============================================================================
#                                                                          MAIN

# retrieve local current path:
dirpath_current=`echo "$NAUTILUS_SCRIPT_CURRENT_URI" \
  | perl -pe '
    s~^file://~~;
    s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`

# lets check if current path is writable:
[ -w "$dirpath_current" ] || {
zenity --error --title "$z_title" \
--text="$z_error_message_cant_create_here"
exit 1
}

# lets check if .hidden file is present:
flag_hidden='# hide-show-links'
if [ `grep "^${flag_hidden}" -c "$dirpath_current/.hidden"` -ge 1 ] ; then
    # removing .hidden file and moving back the backup if exists
    text="$z_success_show_message"
    cmd="rm -f '$dirpath_current/.hidden' && mv '$dirpath_current/.hidden.prelink' '$dirpath_current/.hidden' && xdotool key F5"
elif [ ! -e "$dirpath_current/.hidden" ] ; then
    # creating .hidden file
    text="$z_success_hide_message"
    cmd="find -type l | perl -pe 'BEGIN{print\"${flag_hidden}\n\"}s~^\./~~' | sed -e 's/^\.\///g' -e '/\//d' > '$dirpath_current/.hidden' && xdotool key F5"
else
    # backing up existing .hidden file
    text="$z_success_hide_message"
    cmd="cp -f '$dirpath_current/.hidden' '$dirpath_current/.hidden.prelink' && find -type l | perl -pe 'BEGIN{print\"${flag_hidden}\n\"}s~^\./~~' | sed -e 's/^\.\///g' -e '/\//d' > '$dirpath_current/.hidden' && cat '$dirpath_current/.hidden.prelink' >> '$dirpath_current/.hidden' && sort -u '$dirpath_current/.hidden' && xdotool key F5" 
fi

### DRY RUN: noop

[ $DRY_RUN -eq 1 ] && {
zenity --info --width 170 --title "$z_title" \
--text="DRY RUN
dirpath_current: $dirpath_current
cmd: $cmd
text: $text"
exit 0
}

### GO: let's delete/create/modify the .hidden file

if [ -n "$cmd" ] ; then
eval "$cmd"
if [ $? -eq 0 ] ; then
        # success: display message with notification or with zenity
        if [ -x notify-send ] ; then
            notify-send \
              --urgency="low" \
              --icon="system-run" \
              "$text"
        else
			echo "$text"
        fi
    else
        # error
        zenity --error --title "$z_title" \
          --text="ERROR
dirpath_current: $dirpath_current
cmd:$cmd
text: $text"
        exit 1
    fi
else
    # backing up existing .hidden file
	echo "$text"
    exit 1
fi

exit 0

### EOF
