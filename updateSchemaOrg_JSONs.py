# as updates to NASA SPASE records are pulled via update-pages.sh, the schema.org 
#   metadata to be embedded is also updated
import subprocess, os
from pathlib import Path

home = str(Path.home()).replace("\\", "/")
cwd = str(Path.cwd()).replace("\\", "/")

def main(folder: str) -> None:
    """
    Calls the soso conversion.py script to generate schema.org metadata JSONs for all
        SPASE records found in the given folder.

    :param folder: The path to the directory/text file containing SPASE records that the user
        wishes to create schema.org JSONs for
    """
    input_string = "go\n" # Include newline character since the subprocess expects line-by-line input
    python_interpreter = f"{cwd}/venv/bin/python"
    conversion_path = f"{cwd}/venv/lib/python3.12/site-packages/soso/strategies/spase/conversion.py"

    print(f"Running command: {python_interpreter} {conversion_path} {folder}")
    try:
        result = subprocess.run(
            [f"{python_interpreter}", f"{conversion_path}", f"{folder}"],
            input=input_string,     # Pass the string as input
            capture_output=True,    # Capture stdout and stderr
            text=True,              # Handle input/output as text strings (decodes bytes)
            check=True,             # Raise an exception if the command fails
            #cwd=cwd                # specify working dir of subprocess
        )
        print("Output:", result.stdout)
    except subprocess.CalledProcessError as e:
        print("Error:", e.stderr)

# allow calls from the command line
if __name__ == "__main__":
    from sys import argv

    # if no folder was provided, default script run updates schema.org metadata for
    #   all NASA NumericalData and DisplayData records
    if len(argv) == 1:
        print("No folder arg provided: Updating all NumericalData and DisplayData schema.org metadata.")
        main(f"{home}/NASA/NumericalData")
        main(f"{home}/NASA/DisplayData")
    elif len(argv) == 2:
        if "\\" in str(argv[1]):
            argv[1] = argv[1].replace("\\", "/")
        print(f"Updating schema.org metadata for all SPASE records found in {argv[1]}")
        main(f"{argv[1]}")
    else:
        print("Incorrect number of arguments.")
        print(help(main))