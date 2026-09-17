# called by cron file to have this overriding process automated
# should be done before the `push-pages.sh` call which pushes updated pages to Github
import os, json
from pathlib import Path
from bs4 import BeautifulSoup
from datetime import datetime

home = str(Path.home()).replace("\\", "/")
now = datetime.now()

def main(updateList: str) -> None:
    """
    Overrides the schema.org metadata JSONs for all
        SPASE records found in the file containing
        most recent SPASE updates.

    :param updateList: The path to the directory/text file containing SPASE records that the user
        wishes to create schema.org JSONs for
    """
    # loop through all SPASE_JSONs and insert their contents into the corresponding .html file
    #   found in pages folder
    def get_paths(file: str) -> list:
        """Reads text file containing SPASE directories and extracts all
        file paths present in the directories. Returns these paths within
        a list.

        :param file: A string specifying the path of the text file with
                        directories to extract file paths from.
        :return: A list containing the absolute paths of all files found
                    within the directories found in the given file.
        """

        with open(file, "r") as f:
            paths = []
            for line in f:
                # remove newline
                line = line.strip()
                # check if folder/directory
                if os.path.isdir(line):
                    for root, _, files in os.walk(line):
                        if files:
                            for each in files:
                                paths.append(root + "/" + each)
                else:
                    print(line + " is not a directory and/or does not exist")
        return paths

    def pretty_print_json_file(filename, indent_level=4):
        """
        Reads a JSON file and returns its content as a pretty-printed string.

        Args:
            filename (str): The path to the JSON file.
            indent_level (int): The number of spaces for indentation.

        Returns:
            str: A pretty-printed JSON string.
        """
        try:
            # 1. Read the JSON data from the file into a Python object
            with open(filename, 'r') as file:
                data = json.load(file)

            # 2. Convert the Python object to a pretty-printed JSON string
            pretty_json_string = json.dumps(data, indent=indent_level)
            return pretty_json_string

        except FileNotFoundError:
            return f"Error: The file '{filename}' was not found."
        except json.JSONDecodeError:
            return f"Error: Could not decode JSON from the file '{filename}'."

    changedFiles = get_paths(updateList)
    SPASE_JSONs = []
    for item in changedFiles:
        jsonPath = item.replace(".xml", ".json")
        jsonPath = jsonPath.replace(home, f"{home}/spase-generate-pages/SPASE_JSONs")
        SPASE_JSONs.append(jsonPath)
    if len(SPASE_JSONs) > 0:
        #print(SPASE_JSONs[:10])
        # replace old XSLT generated metadata with new soso metadata for each SPASE_JSON
        for fullJSON_path in SPASE_JSONs:
            #print(fullJSON_path)
            #if "NASA/NumericalData/MMS/4/HotPlasmaCompositionAnalyzer/Burst/Level2/Ion/PT0.625S.json" in fullJSON_path:
            *_, JSON_path = fullJSON_path.partition("SPASE_JSONs/")
            sosoJSON = pretty_print_json_file(fullJSON_path)
            if not sosoJSON.startswith("Error"):
                #print(sosoJSON)
                HTML_path = JSON_path.replace(".json", ".html")
                fullHTML_path = f"{home}/spase-generate-pages/pages/{HTML_path}"
                #print(fullHTML_path)
                with open(fullHTML_path) as xslFile:
                    xslContent = xslFile.read()
                soup = BeautifulSoup(xslContent, 'html.parser')
                head_tag = soup.head
                if head_tag:
                    # also add signposting link needed for FUJI recognition
                    signposting_link = head_tag.find('link', attrs={"rel": "describedby", "type": "application/xml"})
                    if not signposting_link:
                        # 1. Locate the specific target meta tag (only used when landing pages use the older spase.xsl found in tmp/)
                        target_meta = head_tag.find('meta', attrs={"http-equiv": "Content-Type",
                            "content": "text/html; charset=utf-8"})
                        # account for incorrect casing
                        if not target_meta:
                            target_meta = head_tag.find('meta', attrs={"http-equiv": "Content-Type",
                                "content": "text/html; charset=UTF-8"})
                        # check for meta tag with just the charset attribute (newer spase.xsl uses this one)
                        if not target_meta:
                            target_meta = head_tag.find('meta', attrs={"charset": "utf-8"})
                        if not target_meta:
                            target_meta = head_tag.find('meta', attrs={"charset": "UTF-8"})
                        # printout message if still not found
                        if not target_meta:
                            print("meta tag not found in head")
                        else:
                            # 2. Create the new link tag
                            signposting_link = soup.new_tag('link')
                            signposting_link.attrs['rel'] = 'describedby'
                            signposting_link.attrs['href'] = f"https://spase-metadata.org/{HTML_path.replace(".html", ".xml")}"
                            signposting_link.attrs['type'] = "application/xml"

                            # 3. Inject the link tag directly after the target meta tag
                            if target_meta:
                                target_meta.insert_after(signposting_link)

                    # add soso metadata to script tag
                    script_tag = head_tag.find('script', {'type': 'application/ld+json'})
                    if script_tag:
                        script_tag.string = sosoJSON
                        with open(fullHTML_path, 'w') as file:
                            file.write(str(soup.prettify()))
                        print(f"Schema.org metadata successfully updated for {fullHTML_path}.")
                        print()
                    else:
                        # write errors to log file
                        with open(f"{home}/tmp/sosoLog.txt", "a") as f:
                            f.write(f"{now}: No script tag with type='application/ld+json' found in head for {fullHTML_path}\n")
                        #raise ValueError("No script tag with type='application/ld+json' found in head.")
                else:
                    # write errors to log file
                    with open(f"{home}/tmp/sosoLog.txt", "a") as f:
                        f.write(f"{now}: Head tag not found for {fullHTML_path}\n")
                    #raise ValueError("Head tag not found.")
            else:
                # write errors to log file
                with open(f"{home}/tmp/sosoLog.txt", "a") as f:
                    f.write(f"{now}: Encountered error: {sosoJSON} for {fullJSON_path}\n")

    # remove update file for next hourly refresh
    if os.path.exists(updateList):
        # do not remove weekly refresh one
        if "freshSchemaOrgUpdates.txt" not in updateList:
            print(f"Removing {updateList}")
            os.remove(updateList)
        else:
            print(f"Did not remove {updateList}")

# allow calls from the command line
if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        if "\\" in str(argv[1]):
            argv[1] = argv[1].replace("\\", "/")
        print(f"Overriding schema.org metadata for all SPASE records found in {argv[1]}")
        main(f"{argv[1]}")
    else:
        print("Incorrect number of arguments.")
        print(help(main))