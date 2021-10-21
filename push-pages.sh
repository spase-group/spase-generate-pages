#!/bin/bash 

# Refresh the git attached to a folder.
# This will remove all previous commits and add a fresh commit of the folder contents.
#
# Arguments
#  $1: Name of the folder to process (default: pages)
#
# Author: Todd King - 2020-06-26

CONTENT=${1:-pages}
STAMP=`date +"%Y-%m-%d"`

if [ ! -d "$CONTENT" ]; then
   echo "The folder '$CONTENT' does not exist."
   exit
fi

echo "Processing '$CONTENT' ..."
cd $CONTENT
git add .	# Add all the files
git commit -am "Refresh $STAMP"  # Commit the changes
git push # Finally, force update your repository

echo "Done."