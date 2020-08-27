#!/bin/bash
# Get list of files that need updating and copy the files into a destination folder.
# 
# Author: Todd King - 2020/06/26

SRC=${1:-metadata.src}
DEST=${2:-metadata}
PAGES=${3:-pages}

# Clear build area
rm -r -f ${DEST}/*

# Pull any changes to pages area (if attached to git repo)
cd $PAGES
if [ -d ".git" ]; then
	git pull
fi
cd ..

# Process new or changed files
cd $SRC
for D in *; do
    if [ -d "${D}" ]; then
	    echo "# Processing ${D} ..."
        cd ${D}
		git fetch origin
		git diff --name-only master origin/master > /tmp/$$.list
		git pull
		while read line; do 
 		    echo $line
			mkdir -p ../../${DEST}/${D}/`dirname ${line}`;
			cp ${line} ../../${DEST}/${D}/${line}
		done < /tmp/$$.list
		rm /tmp/$$.list
		cd ..
    fi
done
cd ..

# Generate new pages and content
grunt -v