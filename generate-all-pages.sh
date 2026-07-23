#!/bin/bash
# Create pages for files in the metadata source folder. 
# 
# Author: Todd King - 2020/06/26
# Edited by Zach Boquet on 3/10/26

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

# regenerate all NASA NumericalData and DisplayData schema.org metadata and override into landing pages
cd /home/ubuntu/spase-generate-pages
pwd > /home/ubuntu/tmp/cronjob.log 2>&1
rm -rf /home/ubuntu/NASA
cp -r metadata.src/NASA/. /home/ubuntu/NASA/
rm -rf /home/ubuntu/SMWG
cp -r metadata.src/SMWG/. /home/ubuntu/SMWG/
rm -rf SPASE_JSONs
venv/bin/python updateSchemaOrg_JSONs.py #>> /home/ubuntu/tmp/cronjob.log 2>&1
venv/bin/python fixSchema_Org_Metadata.py /home/ubuntu/spase-generate-pages/freshSchemaOrgUpdates.txt #>> /home/ubuntu/tmp/cronjob.log 2>&1