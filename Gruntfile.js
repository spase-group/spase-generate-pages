/*
 * Build SPASE.info static web site from XML 
 *
 * Copyright (c) 2020. Todd King and Regents of the University of California
 * Licensed under the Apache 2.0 license.
 */

 /*
 * Required modules
 *
 * npm install grunt-convert --save-dev
 * npm install grunt-xsltproc --save-dev
 * npm install grunt-contrib-clean --save-dev
 * npm install grunt-contrib-copy --save-dev
 *
 * To build everything
 *     grunt
 * To build the home page
 *     grunt homepage
 * To build listing (index) page for each folder
 *     grunt listing
 */

module.exports = function(grunt) {
	'use strict';

	// Load plug-ins
	grunt.task.loadTasks('./tasks');
	grunt.loadNpmTasks('grunt-convert');
	grunt.loadNpmTasks('grunt-xsltproc');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-assemble');
	
	// Configure tasks
	grunt.initConfig({
		site: {
			src: "src",
			dest: "pages",
			metadata: "metadata",
			stylesheet: "xsl",
			temp: "temp",
			listing: "layout/listing.hbs",
			homepage: "layout/homepage.hbs",
			layout: "layout/default.hbs",
			title: "SPASE.info",
		},
		
		// Defined tasks
		
		// Copy XML file in metadata directory to destination.
	    copy: {
			main: {
			   files: [
				   {
					  expand: true,
					  cwd: '<%= site.metadata %>', // set 'Current Working Directory'
					  src: '**', // Read everything inside the cwd
					  dest: '<%= site.dest %>/', // Destination folder
				   }
				]
			}
		},

		// Process all handlebar files (.hbs) in the temp folder and write to destination.
		assemble: {
			options: {
				flatten: true,
				layout: '<%= site.layout %>'
			},
			home: {
				files: [{
					expand: true,
					extDot: 'last',
					cwd: '<%= site.temp %>',
					src: ['**/*.hbs',],
					dest: '<%= site.dest %>/',
					// ext: '.html',
				}],
			}
		},
	  
		// Transform XML files in metadata folder with an XSLT stylesheet and write output in temporary folder with ".hbs" extension.
		xsltproc: {
			options: {
				stylesheet: '<%= site.stylesheet %>/spase.xsl'
			},
			compile: {
				options: {
					stylesheet: '<%= site.stylesheet %>/spase.xsl'
				},
				files: [{
					expand: true,
					cwd: '<%= site.metadata %>',
					extDot: 'last',
					src: '**/*.xml',
					dest: '<%= site.temp %>',
					ext: '.hbs',
				}]
			}
		},

		// Convert XML files in metadata folder to JSON and write to destination folder.
		convert: {
			options: {
				explicitArray: false,
			},
			xml2json: {
				files: [{
					expand: true,
					cwd: '<%= site.metadata %>',
					extDot: 'last',
					src: '**/*.xml',
					dest: '<%= site.dest %>',
					ext: '.json',
				}]
			}
		},

		// Create index pages for the content of the destination folder. 
		// Target "index" will generate pages for each directory. Target "homepage" will create a home page.
		index_maker: {
			options: {
				files: false,
				folders: true,
				title: '<%= site.title %>',
				data: {
				},
				template: '<%= site.listing %>',
			},
			index: {
				options: {
					template: '<%= site.listing %>',
					exclude: ['README.md', '*.xml', '*.json']					
				},
				expand: true,
				cwd: '<%= site.dest %>',
				src: '**',
				dest: '<%= site.dest %>/'
			},
			homepage: {
				options: {
					template: '<%= site.homepage %>',
					exclude: ['.git', 'README.md', 'LICENSE', 'Deprecated',  '*.xml', '*.json']
				},
				expand: true,
				cwd: '<%= site.dest %>',
				src: ['.'],
				dest: '<%= site.dest %>/'
			}

		},

		// Remove any previously-created files from the destination folder and temporary folder
		clean: {
			build: ['<%= site.dest %>/**/*.html', '<%= site.dest %>/**/*.xml', '<%= site.dest %>/**/*.json'],
			temp: ['<%= site.temp %>']
		}		

	});

	// Define tasks. Task called "default" runs with no command line options
	
	// To "index_maker" before "convert" so that index does not include extra files.
	grunt.registerTask('default', ['xsltproc', 'assemble', 'copy', 'convert', 'index_maker:index', 'index_maker:homepage']);
	grunt.registerTask('listing', ['index_maker:index']);
	grunt.registerTask('homepage', ['index_maker:homepage']);
};
