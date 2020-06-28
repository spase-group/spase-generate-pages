#!/bin/bash
# Get list of files that need updating
# 
# Author: Todd King - 2020/06/26

SRC=${1:-metadata-}
DEST=${2:-metadata}

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
			mkdir -p ../../${DEST}/${D}/`dirname $line`;
			cp ${line} ../../${DEST}/${D}/${line}
		done < /tmp/$$.list
		rm /tmp/$$.list
		cd ..
    fi
done

# Generate new pages and content
grunt -v