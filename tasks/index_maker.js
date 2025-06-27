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
var minimatch = require('minimatch');

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

		parser.registerHelper('crumb', function(param1, options) {
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
			listing: 'index.html',
			exclude: []
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
	    grunt.verbose.writeln(JSON.stringify(f, null, 3));

            f.src.map(function (filename) {
				// Check if file name is to be excluded. Grunt should do this but in some cases it's not perfect.
				var entryName = path.basename(filename);
				// if(options.exclude.includes(testname)) return;
				for(let i =0; i < options.exclude.length; i++) {
					if( minimatch(entryName, options.exclude[i]) ) return;
				}
				
                // Manage Directories
                if (grunt.file.isDir(filename)) {
                    // Create directory object
					var info = [];
					var fileList = [];
					var dirList = [];

grunt.verbose.writeln('at naming_auths');	
	        // Get descriptive labels for Naming Authority index page
	        var fs = require('fs');
	        var na_json = fs.readFileSync('naming_auths.json', 'utf8');
	        var na_obj = JSON.parse(na_json);
	        var na_for = (na_obj.hasOwnProperty('naming_auths')) ? na_obj['naming_auths'] : {};
grunt.verbose.writeln('past naming_auths');	
					
					// var entries = grunt.file.expand({filter: function(src) { return (src != options.listing); } }, path.join(filename, "*") );	
					grunt.verbose.writeln("Processing " + filename);
					//grunt.verbose.writeln("fcount " + filename.split('/').length);
					var depth = filename.split('/').length;
					var is_top_level = (depth < 3) ? true : false; //  pages/CSA: depth = 2
					var parentFolder = path.basename(filename);					
					var entries = fs.readdirSync(filename);
					// SMWT telecon request to ignore case in index listings 2023/09/07
					entries.sort(function (a,b) {
					  return a.toLowerCase().localeCompare(b.toLowerCase());
					});
					entries.map(function(entryName) {
						if(entryName == options.listing) return;	// Don't include generated file in listing
						// if(options.exclude.includes(entryName)) return;	// Don't include the excluded files
						for(let i =0; i < options.exclude.length; i++) {
							if( minimatch(entryName, options.exclude[i]) ) return;
						}
						
						var pathname = path.join(filename, entryName);
						var stat = fs.statSync(pathname);
						
						var entry_label = path.basename(entryName);
						if (is_top_level && na_for.hasOwnProperty(entry_label)) {
						  // Only sub this in for Naming Auth level - CSA can mean different things
						  entry_label = entry_label + ' - ' + na_for[entry_label].title;
						}

						var tempInfo = {
							basename: path.basename(entryName),
							label: entry_label,
							stem: path.basename(entryName, path.extname(entryName)),
							mtime: stat.mtime,
							size: stat.size,
							isDir: grunt.file.isDir(pathname),
						}
						if(tempInfo.isDir) dirList.push(tempInfo);
						else fileList.push(tempInfo);
						info.push(tempInfo);
					});
					
					// Sort with folders and files, place folders first
					// dirList.sort(function(a, b) { a.basename.localeCompare(b.basename, undefined, { sensitivity: 'base' })});
					// fileList.sort(function(a, b) { a.basename.localeCompare(b.basename, undefined, { sensitivity: 'base' })});
					// info = info.concat(dirList, fileList);
					// Sort combined list.
					info.sort(function(a, b) { a.stem.localeCompare(b.stem, undefined, { sensitivity: 'base' })});
					
					// Write generated file
					var dest = f.dest + "/" + options.listing;
					var navPath = filename;
					var n = filename.indexOf("/");
					if(n > 0) navPath = filename.substring(n);
									
					// grunt.verbose.writeln("Writing: " + dest);
					var contents = {
						title: options.title,
						path: navPath,
						parent: parentFolder,
						data: options.data,
						listing: options.listing,
						entries: info
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
