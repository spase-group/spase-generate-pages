# spase-generate-pages
Tools to build the static SPASE resource description web site.

# Getting stated

1. Clone this repo.
2. Change to the cloned repo directory.
3. Install Grunt 

```
npm install grunt --save
```

Install dependencies

```
npm install --save
```

4. Create a folder named "metadata.src" and place SPASE resource descriptions in the folder.
This folder can contain clones of multiple metadata repositories.

5. Optional. Clone the repo for the generated pages.

```
git clone https://github.com/hpde/hpde.io pages
grunt -v
```

6. Generate the pages

Run the script 

```
update-pages.sh"
```

This will create a "metadata" folder which contains all the new or updated resource descriptions and then 
will run the default Grunt task. The generated pages will be placed in the "pages" folder.

To generate pages for the first time or to do a complete manual update, run the script

```
generate-all-pages.sh
```

This will copy all files (excluding git related files) from the metadata source folder to the metadata staging area 
and generate pages. 

7. Update the website

If the "pages" folder is connected to a git repository for the web site, running the script
```
update-git.sh
```

Will do a "git commit" and "git push" to update the website.

# Working with generated pages

The generated pages (in the "pages" folder) are self-contained, static pages. You can view the pages directly from
the file system by loading any ".html" file into your browser. You can explorer the entire generated web site by
starting at the "index.html" in the "pages" folder.

# Custom Builds

You can use "grunt" to do custom builds. The Gruntfile in the project uses default values for locating metadata, page templates 
and where to write generated pages. These values can be set on the command line with the following options:

### -src

The pattern for files to process. Default:'**/*.xml'

### -dest

The folder to place generated pages. Default: "pages"

### -metadata

The folder containing the files to process. Files that match the "-src" pattern will be processed. Default: "metadata"

### -stylesheet

The XML stylesheet for transforming XML files to HTML. Default: "xsl/spase.xsl"

### -temp

The folder to place temporary files. Default: "temp"

### -listing

The Handlebars template for generating a listing of files. Default: "layout/listing.hbs"

### -homepage

The Handlebars template for generating the homepage for the generated pages. Default: "layout/homepage.hbs"

### -layout:

The Handlebars template for the generated pages. Default: "layout/default.hbs",

### -title

The title to place in the generated pages. Default: "HPDE.io"

# For developers

The git is configured to ignore (exclude) the metadata, metadata.src and pages folders, so it is OK to generate
pages in a clone of the generator.

In the scripts Grunt is used to run the tasks to generate each part of the generated website which is placed in the "pages" folder.
You can run the build of "pages" folder manually with the command:

```
grunt  -v
```

This will create a "pages" folder containing the built files. The "pages" folder could be
the clone of a website repository. The ".git" folder information should be preserved between builds
to retain the git repository connection.

# Automating updates

On system that can run scripts on a schedule simply run the "update-pages.sh" followed by the "update-git.sh" scripts.
Occasionally the "compact-git.sh" should be run to improve performance speeds.

# Tasks

**default**: Run 'xsltproc', 'assemble', 'copy', 'convert', 'index_maker:index', 'index_maker:homepage'.

**copy**: Copy XML file in metadata directory to destination.

**assemble**: Process all handlebar files (.hbs) in the temp folder and write to destination.

**xsltproc**: Transform XML files in metadata folder with an XSLT stylesheet and write output in temporary folder with ".hbs" extension.

**convert**: Convert XML files in metadata folder to JSON and write to destination folder.

**index_maker**: Create index pages for the content of the destination folder.  Target "index" will generate pages for each directory. Target "homepage" will create a home page.

**sitemap_xml**: Generate a sitemap in XML format.

**clean**: Remove any previously-created files from the destination folder and temporary folder

# Tools

**compact-git.sh**: Bash script to refresh the git attached to "page". This will remove all previous commits and add a fresh commit of the pages folder contents.

**update-git.sh**: Bash script to commit the current contents of the folder with a message that includes a date and then push the repo.

**update-metadata.sh**:  Bash script to do a "git pull" on every folder in another folder. 

**update-pages.sh**:  Bash script to determine new and updated resource descriptions and generate pages for each one. 

**generate-all-pages.sh**:  Bash script to create pages for files in the metadata source folder. 

## Notes on running scripts

A good practice is to explicitly specify the shell to run a script with a command like:

```
bash script.sh
```

This will work on all operating systems that have a bash shell available.

# Optimization
Both the metadata source and the generated pages can contain a lot of files. Here are a couple ways to optimize working with the files.

## Updating only what has changed

Note: The script "update-pages.sh" uses this approach.

The Grunt tasks process files that are in the "metadata" folder. This folder can contain all the metadata for all the pages. Processing all the 
metadata everything any change is made can be very time consuming. A more optimal approach is to process only those metadata descriptions (files) that
have changed. One way to do this is to store the source metadata in a separate location and then get a list of those files that have been added or changed.
With git you can get a list or new or changed files with the following in the git clone folder:

```
git fetch origin
git diff --name-only master origin/master > /tmp/$$.list
```
Then copy these files into the "metadata" folder and process just those files. 
```
git pull
while read line; do 
	echo $line
	mkdir -p ../metadata/`dirname ${line}`;
	cp ${line} ../metadata/${line}
done < /tmp/$$.list
```

## Creating a compact git repository

Note: The script "compact-git.sh" using this approach.

The "pages" repository can contain a large number of files. Often for a generated web site it is not
necessary to get the full revision history. Making the git repository as compact as possible can speed up push/pull. 
The preferred method is to eliminate all prior commits do the following:

```
git checkout --orphan temp	# Create temporary branch
git add -A	# Add all the files
git commit -am "commit message"  # Commit the changes
git branch -D master	# Delete the master branch
git branch -m master  # Rename the current branch to master
git repack -d   # Place objects not in a pack, into a pack and remove redundant packs
git gc   # Cleanup unnecessary files and optimize the local repository
git push -f origin master # Finally, force update your repository
```

**Warning**: With this method prior clones will not be able to do a "git pull" because the tracking information is lost.
You must always use "git clone" to get a fresh copy.
