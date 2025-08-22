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

$t1 = date ('Y-m-d h:i:s');
print "prune init $t1\n";

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

/*
 * Clean out empty list pages (descriptor group parents).
 * If the landing page link format changes this may need to be adjusted.
 */

$found = `find $PAGES_ROOT -name index.html`;
$all_indices = explode ("\n", $found);
foreach ($all_indices as $f) {
  if (strlen ($f) < 1) {continue;}
  $here = __DIR__;
  $target = "$here/$f";
  $html = file_get_contents ($target);
  if (strpos($html, 'target=') === false) {
    print "Deleting $target\n";
    unlink($target);
  }
}


$t2 = date ('Y-m-d h:i:s');
print "prune complete $t2\n";

