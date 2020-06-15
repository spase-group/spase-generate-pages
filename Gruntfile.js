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
	
	// Configure tasks
	grunt.initConfig({
		site: {
			src: "src",
			dest: "pages",
			metadata: "metadata",
			stylesheet: "xsl/spase.xsl",
			listing: "layout/listing.hbs",
			homepage: "layout/homepage.hbs",
			title: "SPASE.info",
		},
		
		// COMPILE AND EXECUTE TASKS
		// Copy XML
	    copy: {
			main: {
			   files: [
				   {
					  expand: true,
					  cwd: '<%= site.src %>', // set 'Current Working Directory'
					  src: '**', // Read everything inside the cwd
					  dest: '<%= site.dest %>/', // Destination folder
				   },
				   {
					  expand: true,
					  cwd: '<%= site.metadata %>', // set 'Current Working Directory'
					  src: '**', // Read everything inside the cwd
					  dest: '<%= site.dest %>/', // Destination folder
				   }
				]
			}
		},

		// Generate HTML version using stylesheet
		xsltproc: {
			options: {
				stylesheet: '<%= site.stylesheet %>'
			},
			compile: {
				files: [{
					expand: true,
					cwd: '<%= site.metadata %>',
					src: '**/*.xml',
					dest: '<%= site.dest %>',
					ext: '.html'
				}]
			}
		},

		// Create JSON version 
		convert: {
			options: {
				explicitArray: false,
			},
			xml2json: {
				files: [{
					expand: true,
					cwd: '<%= site.src %>',
					src: '**/*.xml',
					dest: '<%= site.dest %>',
					ext: '.json'
				}]
			}
		},

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
				expand: true,
				cwd: '<%= site.dest %>',
				src: '**',
				dest: '<%= site.dest %>/'
			},
			homepage: {
				options: {
					template: '<%= site.homepage %>',
				},
				expand: true,
				cwd: '<%= site.dest %>',
				src: '.',
				dest: '<%= site.dest %>/'
			}

		},
  
		// Before generating any new files,
		// remove any previously-created files.
		clean: ['<%= site.dest %>/**']

	});

	// Define tasks. Task called "default" runs with no command line options
	grunt.registerTask('default', ['xsltproc', 'convert', 'index_maker']);
	grunt.registerTask('listing', ['index_maker:index']);
	grunt.registerTask('homepage', ['index_maker:homepage']);
};
