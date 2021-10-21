#!/bin/bash 

SRC=${1:-metadata.src}

cd $SRC

for FILE in *; do
    if [ -d "$FILE" ]; then
        echo -n "$FILE : "
        cd "$FILE"
        git pull
        cd ..
    fi
done