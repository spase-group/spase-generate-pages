<?php

/*
 * Clean out all generated hpde.io landing pages prior to a full landing page refresh.
 * This removes landing pages for renamed descriptors.
 * This uses the https://hpde.io/naming_auths.json list of naming authorities.
 */

$root = __DIR__ . '/pages';

$logfile = '/home/ubuntu//logs/full_pull.log';

$na_set = `curl https://hpde.io/naming_auths.json`;

$list = json_decode ($na_set, JSON_OBJECT_AS_ARRAY);
$ALL_AUTH_INFO = $list['naming_auths'];
$NAMING_AUTHS = array_keys ($ALL_AUTH_INFO);

file_put_contents ($logfile, "Delete pages: " . date ("Y-m-d h:i:s") . "\n", FILE_APPEND);

foreach ($NAMING_AUTHS as $folder) {
  $here = "$root/$folder";

print "$here\n";
  $result = '';
  if (file_exists ($here)) {
    $cmd = "rm -rf $here"; 
print "$cmd\n";
    $result = `$cmd`;
  }

  print "$result\n";

//  chdir ($root);
}

