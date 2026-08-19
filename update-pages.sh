#!/bin/bash
# Get list of files that need updating and copy the files into a destination folder.
# 
# Author: Todd King - 2020/06/26
# Edited by Zach Boquet on 3/10/26

SRC=${1:-metadata.src}
DEST=${2:-metadata}
PAGES=${3:-pages}
${NASA_Changed:-"false"}

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
		changes=$(git diff --name-only master origin/master)
		git pull
		# copy over newest files to upper-level repo folders used in schema.org metadata updates
		if [ -n "$changes" ] && [[ "${D}" == "NASA" || "${D}" == "SMWG" ]]; then
			echo "# Processing ${D} ..." >> /home/ubuntu/tmp/cronjob.log 2>&1
			echo "Changed records are $changes" >> /home/ubuntu/tmp/cronjob.log 2>&1
			if [[ "${D}" == "SMWG" ]]; then
				echo "Updating top-level SMWG folder" >> /home/ubuntu/tmp/cronjob.log 2>&1
				rm -rf /home/ubuntu/SMWG && echo "SMWG Folder deleted!" >> /home/ubuntu/tmp/cronjob.log 2>&1
				cp -r . /home/ubuntu/SMWG/ && echo "SMWG Folder copied!" >> /home/ubuntu/tmp/cronjob.log 2>&1
			elif [[ "${D}" == "NASA" ]]; then
				echo "Updating top-level NASA folder" >> /home/ubuntu/tmp/cronjob.log 2>&1
				#rm -rf /home/ubuntu/NASA/* && cp -r ${SRC}/NASA/* /home/ubuntu/NASA/
				rm -rf /home/ubuntu/NASA && echo "NASA Folder deleted!" >> /home/ubuntu/tmp/cronjob.log 2>&1
				cp -r . /home/ubuntu/NASA/ && echo "NASA Folder copied!" >> /home/ubuntu/tmp/cronjob.log 2>&1
			else echo "No NASA/SMWG updates were found." >> /home/ubuntu/tmp/cronjob.log 2>&1
			fi
		fi
		# initialize array to hold unique IDs in need of metadata update
		updateList=()
		while read line; do 
 		    echo $line
			mkdir -p ../../${DEST}/${D}/`dirname ${line}`;
			cp ${line} ../../${DEST}/${D}/${line}
			# update schema.org metadata JSONs for changed files if they are NASA
			if [[ "${D}" == "NASA" ]]; then
				if [[ "$line" == *"NumericalData/"* || "$line" == *"DisplayData/"* ]]; then
					cd ../../
					changedDIR="/home/ubuntu/NASA/`dirname ${line}`"
					FILE="/home/ubuntu/tmp/schemaOrg_Overrides.txt"
					# if directory not already in update list, add it
					grep -qxF -- "$changedDIR" "$FILE" || echo "$changedDIR" >> "$FILE"
					# Check if the directory has already had its metadata JSON updated, add if not
					if [[ ! " ${updateList[*]} " =~ " ${changedDIR} " ]]; then
						updateList+=("$changedDIR")
						venv/bin/python updateSchemaOrg_JSONs.py "$changedDIR" >> /home/ubuntu/tmp/cronjob.log 2>&1
					fi
					NASA_Changed="true"
				fi
			# update schema.org metadata JSON for records which link to changed SMWG records
			elif [[ "${D}" == "SMWG" ]]; then
				if [[ "$line" == *"Person/"* || "$line" == *"Instrument/"* ]]; then
					# find all NASA DisplayData/NumericalData records the linked record is found in
					name_only=$(echo "$line" | sed 's/\.xml$//')
					echo "Name of Person/Instrument changed is $name_only" >> /home/ubuntu/tmp/cronjob.log 2>&1
					if [[ "$line" == *"Person/"* ]]; then
						echo "This Person appears in the following records: $(grep -rl --exclude-dir="*.git*" "<PersonID>spase://${name_only}</PersonID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/")" >> /home/ubuntu/tmp/cronjob.log 2>&1
						readarray -t linkedRecords < <(grep -rl --exclude-dir="*.git*" "<PersonID>spase://${name_only}</PersonID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/") >> /home/ubuntu/tmp/cronjob.log 2>&1
						#linkedRecords=$(grep -rl --exclude-dir="*.git*" "<PersonID>spase://${name_only}</PersonID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/")
					elif [[ "$line" == *"Instrument/"* ]]; then
						echo "This Instrument appears in the following records: $(grep -rl --exclude-dir="*.git*" "<InstrumentID>spase://${name_only}</InstrumentID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/")" >> /home/ubuntu/tmp/cronjob.log 2>&1
						readarray -t linkedRecords < <(grep -rl --exclude-dir="*.git*" "<InstrumentID>spase://${name_only}</InstrumentID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/") >> /home/ubuntu/tmp/cronjob.log 2>&1
						#linkedRecords=$(grep -rl --exclude-dir="*.git*" "<InstrumentID>spase://${name_only}</InstrumentID>"\$ /home/ubuntu/NASA | grep -E "NumericalData/|DisplayData/")					
					fi
					echo "# of linked records are ${#linkedRecords[@]}" >> /home/ubuntu/tmp/cronjob.log 2>&1
					echo "${linkedRecords[@]}" >> /home/ubuntu/tmp/cronjob.log 2>&1
					cd ../../
					# add these records to update list
					for matched_line in "${linkedRecords[@]}"; do
						echo "After SMWG record update, updating linked record: $matched_line" >> /home/ubuntu/tmp/cronjob.log 2>&1
						changedDIR="/home/ubuntu/NASA/`dirname ${matched_line}`"
						FILE="/home/ubuntu/tmp/schemaOrg_Overrides.txt"
						# if directory not already in update list, add it
						grep -qxF -- "$changedDIR" "$FILE" || echo "$changedDIR" >> "$FILE"
						echo "Calling updateSchemaOrg_JSONs.py on folder: $changedDIR" >> /home/ubuntu/tmp/cronjob.log 2>&1
						# Check if the directory has already had its metadata JSON updated, add if not
						if [[ ! " ${updateList[*]} " =~ " ${changedDIR} " ]]; then
							updateList+=("$changedDIR")
							venv/bin/python updateSchemaOrg_JSONs.py "$changedDIR" >> /home/ubuntu/tmp/cronjob.log 2>&1
						fi
						NASA_Changed="true"
					done
				fi
			fi
			cd "${SRC}/${D}"
		done < /tmp/$$.list
		rm /tmp/$$.list
		cd ..
    fi
done
cd ..

# Generate new pages and content
grunt -v

pwd
# run schema.org metadata overwrite for NASA dataset records
venv/bin/python fixSchema_Org_Metadata.py /home/ubuntu/spase-generate-pages/freshSchemaOrgUpdates.txt >> /home/ubuntu/tmp/cronjob.log 2>&1
