#!/bin/bash 

# Refresh the git attached to a folder.
# This will remove all previous commits and add a fresh commit of the folder contents.
#
# Arguments
#  $1: Name of the folder to process (default: pages)
#
# Author: Todd King - 2020-06-26

CONTENT=${1:-metadata.src}

if [ ! -d "$CONTENT" ]; then
   echo "The folder '$CONTENT' does not exist."
   exit
fi

echo "Processing '$CONTENT' ..."
cd $CONTENT
for D in *; do
    if [ -d "${D}" ]; then
        echo "${D}"   # your processing here
		cd "${D}"
		git pull
		cd ..
    fi
done

echo "Done."