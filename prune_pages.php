<?php

/*
 * This script removes landing pages for Spase descriptors that have been deleted
 * or renamed and moved to a new location.
 * Each landing page is cross-checked against the current descriptor repository.
 * If there is no corresponding descriptor xml file in the repository, the html, xml
 * and json files in the landing page folder are deleted.
 */
 
//define ('PAGES_ROOT', 'pages');
//define ('REPO_ROOT', 'metadata.src');

$PAGES_ROOT = 'pages';
$REPO_ROOT = 'metadata.src';

// These are non-descriptor files that must remain
$skips = array ('index.html', 'metadata.html');

$htmls = `find $PAGES_ROOT -name "*.html"`;

$files = explode ("\n", $htmls);

foreach ($files as $f) {
  if (strlen ($f) < 1) {
    continue;
  }

  // Ignore non-descriptor landing pages
  $ignore = false;
  foreach ($skips as $s) {
    if (strpos ($f, $s) !== false) {
      $ignore = true;
    }
  }
  if ($ignore) {
    continue;
  }

  // See if this landing page still has a descriptor in the Spase repository
  $descriptor = str_replace ($PAGES_ROOT, $REPO_ROOT, $f);
  $descriptor = str_replace ('.html', '.xml', $descriptor);
  if (file_exists ($descriptor)) {
    continue;
  }
  $json = str_replace ('.html', '.json', $f);
  $xml = str_replace ('.html', '.xml', $f);
  print "deleting $f\n $json\n $xml\n";
  unlink ($f);
  unlink ($json);
  unlink ($xml);
}

