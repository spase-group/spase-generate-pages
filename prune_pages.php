<?php

/*
 * This script removes landing pages for Spase descriptors that have been deleted
 * or renamed and moved to a new location.
 * Each landing page is cross-checked against the current descriptor repository.
 * If there is no corresponding descriptor xml file in the repository, the html, xml
 * and json files in the landing page folder are deleted.
 * If this results in an empty directory, the index.html and directory are also deleted.
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
// TODO: fix this so it doesn't remove the homepage

$found = `find $PAGES_ROOT -name index.html`;
$all_indices = explode ("\n", $found);
foreach ($all_indices as $f) {
  if (strlen ($f) < 1) {continue;}
  $here = __DIR__;
  //$target = "$here/$f";
  $target = "$f";
  //print "$f\n";
  // if the directory does not have any other files, delete the index.html
  $dirPath = dirname($target);
  // Ensure the target directory actually exists
  if (is_dir($dirPath)) {
      
      // Scan everything inside the directory
      $items = scandir($dirPath);
      
      $files = [];
      $hasFolders = false;

      foreach ($items as $item) {
          // Skip the standard current (.) and parent (..) directory pointers
          if ($item === '.' || $item === '..') {
              continue;
          }

          $fullPath = $dirPath . DIRECTORY_SEPARATOR . $item;

          // Categorize the item
          if (is_dir($fullPath)) {
              $hasFolders = true;
              break; // Stop checking further if a folder is found
          } elseif (is_file($fullPath)) {
              $files[] = $fullPath;
          }
      }

      // Delete the file if NO folders exist and EXACTLY one file exists
      if (!$hasFolders && count($files) === 1) {
          unlink($files[0]);
          echo "Successfully deleted: " . $files[0];
          // In order to fully clean out empty landing page directories, also need to delete the
          //  directory itself and fix subsequent index.html files which linked to that index.html
          // delete the empty directory
          print "\nDeleting $dirPath\n";
          rmdir($dirPath);
          // remove invalid references to now removed index.html
          $newTarget = basename($dirPath) . "/" . basename($target);
          $parent = dirname($dirPath);
          $upperIndex = $parent . "/index.html";
          $html = file_get_contents ($upperIndex);
          if (strpos($html, "href=\"$newTarget\"") !== false) {
            // remove this line from index.html: class = "listview"
            // Load HTML string safely
            $dom = new DOMDocument();
            // Disable standard libxml errors for malformed HTML
            libxml_use_internal_errors(true);
            $dom->loadHTML('<?xml encoding="utf-8" ?>' . $html);
            libxml_clear_errors();

            // Initialize XPath
            $xpath = new DOMXPath($dom);

            // Target elements with the "listview" class
            $nodes = $xpath->query('//ul[contains(concat(" ", normalize-space(@class), " "), " listview ")]/li');

            // Loop through and delete line linking to old index.html
            // Loop backwards through nodes to safely delete during iteration
            for ($i = $nodes->length - 1; $i >= 0; $i--) {
                $node = $nodes->item($i);

                // Find the <a> tag inside this <li> to inspect the actual link URL
                $aTag = $xpath->query('.//a', $node)->item(0);
                
                if ($aTag) {
                    $hrefValue = $aTag->getAttribute('href');
                    
                    // Check the actual URL path instead of just the visible text
                    if (strpos($hrefValue, $newTarget) !== false) {
                        print "Deleting HTML elt with link to now deleted $newTarget\n";
                        $node->parentNode->removeChild($node);
                    }
                }
            }

            // Generate the cleaned HTML string
            $updatedHtml = $dom->saveHTML();

            // Overwrite the original file with the modified content
            file_put_contents($upperIndex, $updatedHtml);
          }
      } //else {
          //echo "Conditions not met. File not deleted.\n";
      //}
  } else {
      echo "The specified path is not a valid directory.";
  }
}


$t2 = date ('Y-m-d h:i:s');
print "prune complete $t2\n";

