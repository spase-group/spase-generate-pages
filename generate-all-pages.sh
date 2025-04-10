#!/bin/bash
# Create pages for files in the metadata source folder. 
# 
# Author: Todd King - 2020/06/26

SRC=${1:-metadata.src}
DEST=${2:-metadata}

# Clear build area
rm -r -f ${DEST}/*

# Copy all files to generation area
cd $SRC
tar -v -c -f - --exclude .git --exclude .github . | (cd ../${DEST}; tar -x -f -)
cd ..

# Generate new pages and content
grunt -v copy_op
grunt -v convert_op
grunt -v
