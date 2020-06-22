# spase-info-node
Tools to build the static spase.info web site.

# Usage
Install Grunt 

```
npm install grunt --save
```

Install dependencies

```
npm install --save
```

Create a folder named "metadata" and place SPASE resource descriptions in the folder.
This folder can contain clones of metadata repositories.

Run Grunt  to build pages

```
grunt  -v
```

This will create a "pages" folder containing the built files. The "pages" folder could be
the clone of a website repository. The ".git" folder information should be preserved between builds
to retain the git repository connection.

# Tasks

**default**: Run 'xsltproc', 'assemble', 'copy', 'convert', 'index_maker:index', 'index_maker:homepage'.

**copy**: Copy XML file in metadata directory to destination.
**assemble**: Process all handlebar files (.hbs) in the temp folder and write to destination.
**xsltproc**: Transform XML files in metadata folder with an XSLT stylesheet and write output in temporary folder with ".hbs" extension.
**convert**: Convert XML files in metadata folder to JSON and write to destination folder.
**index_maker**: Create index pages for the content of the destination folder.  Target "index" will generate pages for each directory. Target "homepage" will create a home page.
**clean**: Remove any previously-created files from the destination folder and temporary folder

# Tools

**refresh.sh**: Bash script to refresh the git attached to "page". This will remove all previous commits and add a fresh commit of the pages folder contents.

# Optimization

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
