/*
 * Build HPDE resource static web site from the XML descriptions.
 *
 * Copyright (c) 2020. Todd King and Regents of the University of California
 * Licensed under the Apache 2.0 license.
 */

/* Options:
 *	src: Pattern for files to process. Default: '**\/*.xml'
 *	dest: The folder to write the generated pages. Default: "pages"
 * 	metadata: The folder containing the XML to transform. Default: "metadata"
 *  stylesheet: The XML stylesheet to transform the XML to HTML. Default: "xsl/spase.xsl"
 * 	temp: The folder to write temporary files. Default: "temp"
 *  listing: The Handlebars file to generate the listing of landing pages. Default: "layout/listing.hbs"
 *  homepage: The Handlebars file to generate the homepage. Default: "layout/homepage.hbs"
 *	layout: The Handlebars file for generating the landing page. Default: "layout/default.hbs"
 *  title: The title for the web site. Default: "HPDE.io",
*/

 /*
 * Required modules
 *
 * npm install grunt-convert --save-dev
 * npm install grunt-xsltproc --save-dev
 * npm install grunt-contrib-clean --save-dev
 * npm install grunt-contrib-copy --save-dev
 *
 * Required installs
 * apt-get install xsltproc
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
	grunt.loadNpmTasks('grunt-sitemap-xml');	
	
	// Configure tasks
	grunt.initConfig({
		site: {
			src: 		grunt.option('src') || '**/*.xml', // Read everything inside the cwd
			dest: 		grunt.option('dest') || "pages",
			metadata: 	grunt.option('metadata') || "metadata",
			stylesheet: grunt.option('xsl') || "xsl/spase.xsl",
			temp: 		grunt.option('temp') || "temp",
			listing: 	grunt.option('listing') || "layout/listing.hbs",
			homepage: 	grunt.option('homepage') || "layout/homepage.hbs",
			layout: 	grunt.option('layout') || "layout/default.hbs",
			title: 		grunt.option('title') || "HPDE.io <a href='https://spase-group.org/'>SPASE</a> landing pages.",
		},
		
		// Defined tasks
		
		// Copy XML file in metadata directory to destination.
	    copy: {
			xml: {
			   files: [
				   {
					  expand: true,
					  cwd: '<%= site.metadata %>', // set 'Current Working Directory'
					  src: '<%= site.src %>', // Source files
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
				stylesheet: '<%= site.stylesheet %>'
			},
			compile: {
				options: {
					stylesheet: '<%= site.stylesheet %>'
				},
				files: [{
					expand: true,
					cwd: '<%= site.metadata %>',
					extDot: 'last',
					src: '<%= site.src %>', // Source files
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
					src: '<%= site.src %>', // Source files
					dest: '<%= site.dest %>',
					ext: '.json',
				}]
			}
		},

		// Create sitemap
		sitemap_xml: {
			build: {
				options: {
					siteRoot: 'https://spase-metadata.org',
					stripIndex: false,
					priority: 0.8,
					changeFreq: 'daily',
					pretty: true					
				},
				files: [
					{
						cwd: '<%= site.dest %>',
						src: ['**/*.html', '!Deprecated/**'],
						dest: '<%= site.dest %>/sitemap.xml'
					}
				]
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
					exclude: ['.git', 'README.md', 'LICENSE',  'CNAME', 'Deprecated',  '*.xml', '*.json']
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
	grunt.registerTask('default', ['xsltproc', 'assemble', 'copy', 'convert', 'index_maker:index', 'index_maker:homepage', 'sitemap_xml', 'clean:temp']);
	grunt.registerTask('html', ['xsltproc', 'assemble', 'clean:temp']);
	grunt.registerTask('listing', ['index_maker:index']);
	grunt.registerTask('homepage', ['index_maker:homepage']);
	grunt.registerTask('convert_op', ['convert']);
	grunt.registerTask('copy_op', ['copy']);
};
