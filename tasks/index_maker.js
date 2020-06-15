/*
 * grunt-folder-list
 * https://github.com/roughcoder/grunt-folder-list
 *
 * Copyright (c) 2014 Neil Barton
 * Licensed under the MIT license.
 */

'use strict';
var fs = require("fs"); //Load the filesystem module
var path = require("path"); // Path tools
var handlebars = require('handlebars');
var chalk = require('chalk');

module.exports = function (grunt) {

    // Please see the Grunt documentation for more information regarding task
    // creation: http://gruntjs.com/creating-tasks

	// Function to return the file size back in MB
	function getFilesizeInBytes(filename) {
		var stats = fs.statSync(filename)
		var fileSizeInBytes = stats["size"]
		return fileSizeInBytes / 1000000.0
	}

	// Function to get the extension a filename
	function getExtension(filename) {
		var ext = path.extname(filename || '').split('.');
		return ext[ext.length - 1];
	}
	
	// Function to get template parser
	function getTemplateParser (options) {
		var parser = handlebars.create(); // each task has its own instance
		var p;

		if (options.helpers) {
			for (p in options.helpers) {
				if (options.helpers.hasOwnProperty(p)) {
					parser.registerHelper(p, options.helpers[p]);
				}
			}
		}

		return parser;
	}
	
    grunt.registerMultiTask('index_maker', 'Generates an index of folder contents.', function () {
        // Merge task-specific and/or target-specific options with these defaults.
        var options = this.options({
            files: true,
            folders: true,
            preserveExtension: false, // ignored if path is expanded
            encoding: grunt.file.defaultEncoding,
			template: 'template.hbs',
			listing: 'index.html'
       });
	   var processed = 0;
	   
		grunt.log.writeln('Compiling template file: ' + chalk.cyan(options.template));
		
	   var parser = getTemplateParser(options);

		// Check the src files before using them
		if (!grunt.file.exists(options.template)) {
			grunt.log.warn('Template file "' + options.template + '" not found.');
			return false;
		}

		grunt.log.writeln('Compiling template file: ' + chalk.cyan(options.template));

		var template = parser.compile(grunt.file.read(options.template));

        // Iterate over all specified file groups.
        this.files.forEach(function (f) {

            // Create a cmd var even if not used to reduce errors
            var cwd = '';
            if (f.cwd) {
                cwd = f.cwd;
            }
			
			// grunt.verbose.writeln(JSON.stringify(f, null, 3));

            f.src.map(function (filename) {

                // Manage Directories
                if (grunt.file.isDir(filename)) {
                    // Create directory object
					var info = [];
					var fileList = [];
					var dirList = [];
					
					// var entries = grunt.file.expand({filter: function(src) { return (src != options.listing); } }, path.join(filename, "*") );	
					var parentFolder = path.basename(filename);					
					var entries = fs.readdirSync(filename);
					grunt.verbose.writeln("entries: " + entries);
					entries.map(function(entryName) {
						if(entryName == options.listing) return;	// Don't include generated file in listing
						var pathname = path.join(filename, entryName);
						var stat = fs.statSync(pathname);
						// grunt.verbose.writeln(JSON.stringify(stat, null, 3));
						var tempInfo = {
							basename: path.basename(entryName),
							mtime: stat.mtime,
							size: stat.size,
							isDir: grunt.file.isDir(pathname),
						}
						if(tempInfo.isDir) dirList.push(tempInfo);
						else fileList.push(tempInfo);
					});
					
					// Sort with folders and files, the place folders first
					dirList.sort(function(a, b) { a.basename.localeCompare(b.basename, undefined, { sensitivity: 'base' })});
					fileList.sort(function(a, b) { a.basename.localeCompare(b.basename, undefined, { sensitivity: 'base' })});
					info = info.concat(dirList, fileList);
					
					// Write generated file
					grunt.log.writeln("destination: " + f.dest);
					var dest = f.dest + "/" + options.listing;

					grunt.verbose.writeln("Writing: " + dest);
					grunt.verbose.writeln('Info: ');
					var contents = {
						title: options.title,
						parent: parentFolder,
						data: options.data,
						listing: options.listing,
						paths: info
					}
					grunt.verbose.writeln(JSON.stringify(contents, null, 3));
					
					grunt.file.write(dest, template(contents), {
						encoding: options.encoding
					});
				}
			});
			
/*
            // Output variables
            var structure = [],
                tempInfo = {},
                format = getExtension(f.dest);

            // Parse files

                // Manage Files
                if (grunt.file.isFile(cwd + filename)) {
                    // Create file object
                    tempInfo = {
                        location: filename,
                        filename: path.basename(cwd + filename),
                        type: 'file',
                        size: getFilesizeInBytes(cwd + filename),
                        depth: filename.split('/').length - 1,
                        filetype: getExtension(cwd + filename)
                    }
                    if (options.files) {
                        structure.push(tempInfo);
                    }
                }
            });
*/


			/*
			grunt.file.write(dest, tpl(data), {
				encoding: options.encoding
			});
			*/
			
			processed = (processed + 1);
/*
			// Convert structure object to JSON
            var contents = JSON.stringify(structure);

            // Check if yml
            if (format === 'yml' || format === 'ymal') {
                contents = to.format.yaml.stringify(contents);
            }

            // Write out the file
            grunt.file.write(f.dest, contents);

            // Print a success message.
            grunt.log.writeln('File "' + f.dest + '" created.');
*/
        });
    });

};
