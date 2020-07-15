#!/bin/bash 

# Refresh the git attached to a folder.
# This will remove all previous commits and add a fresh commit of the folder contents.
#
# Arguments
#  $1: Name of the folder to process (default: pages)
#
# Author: Todd King

CONTENT=${1:-pages}
STAMP=`date +"%Y-%m-%d"`

if [ ! -d "$CONTENT" ]; then
   echo "The folder '$CONTENT' does not exist."
   exit
fi

echo "Processing '$CONTENT' ..."
cd $CONTENT
git checkout --orphan temp	# Create temporary branch
git add -A	# Add all the files
git commit -am "Refresh $STAMP"  # Commit the changes
git branch -D master	# Delete the master branch
git branch -m master  # Rename the current branch to master
echo "Optimizing ..."
git repack -d
git gc
echo "Pushing to repo ..."
git push -f origin master # Finally, force update your repository

echo "Done."