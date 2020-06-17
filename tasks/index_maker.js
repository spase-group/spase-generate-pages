/*
 * index_maker
 * https://github.com/roughcoder/grunt-folder-list
 *
 * Generates an index of folder contents and write the index in the folder.
 *
 * Copyright (c) 2020 Todd King
 * Licensed under the APache 2.0 license.
 */

'use strict';
var fs = require("fs"); //Load the filesystem module
var path = require("path"); // Path tools
var handlebars = require('handlebars');
var chalk = require('chalk');

module.exports = function (grunt) {

    // Please see the Grunt documentation for more information regarding task
    // creation: http://gruntjs.com/creating-tasks

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

		parser.registerHelper('clean', function(param1, options) {
			return param1.replace(/.html$/, "");
		});
		
		parser.registerHelper('target', function(param1, options) {
			if(param1.endsWith('.html')) return('_blank');
			return('_self');
		});
		
		return parser;
	}
	
    grunt.registerMultiTask('index_maker', 'Generates an index of folder contents and write the index in the folder.', function () {
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
	   
	   var parser = getTemplateParser(options);

		// Check the src files before using them
		if (!grunt.file.exists(options.template)) {
			grunt.log.warn('Template file "' + options.template + '" not found.');
			return false;
		}

		grunt.verbose.writeln('Compiling template file: ' + chalk.cyan(options.template));

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
				// Check if file name is to excluded. Grunt should do this but in some cases it's not perfect.
				var testname = path.basename(filename);
				if(options.exclude.includes(testname)) return;
				
                // Manage Directories
                if (grunt.file.isDir(filename)) {
                    // Create directory object
					var info = [];
					var fileList = [];
					var dirList = [];
					
					// var entries = grunt.file.expand({filter: function(src) { return (src != options.listing); } }, path.join(filename, "*") );	
					grunt.verbose.writeln("Processing " + filename);
					var parentFolder = path.basename(filename);					
					var entries = fs.readdirSync(filename);
					entries.map(function(entryName) {
						if(entryName == options.listing) return;	// Don't include generated file in listing
						if(options.exclude.includes(entryName)) return;	// Don't include the excluded files
						
						var pathname = path.join(filename, entryName);
						var stat = fs.statSync(pathname);

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
					var dest = f.dest + "/" + options.listing;

					// grunt.verbose.writeln("Writing: " + dest);
					var contents = {
						title: options.title,
						parent: parentFolder,
						data: options.data,
						listing: options.listing,
						paths: info
					}
					
					grunt.file.write(dest, template(contents), {
						encoding: options.encoding
					});
				}
			});
					
			processed = (processed + 1);
        });
		grunt.verbose.writeln("Processed " + processed + (processed == 1) ? "file." : "files.");
    });

};
